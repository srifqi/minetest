/*
Minetest
Copyright (C) 2010-2013 celeron55, Perttu Ahola <celeron55@gmail.com>
Copyright (C) 2017 numzero, Lobachevskiy Vitaliy <numzer0@yandex.ru>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#include "plain.h"
#include "client/client.h"
#include "client/shader.h"
#include "settings.h"

inline u32 scaledown(u32 coef, u32 size)
{
	return (size + coef - 1) / coef;
}

RenderingCorePlain::RenderingCorePlain(
	IrrlichtDevice *_device, Client *_client, Hud *_hud)
	: RenderingCore(_device, _client, _hud)
{
	scale = g_settings->getU16("undersampling");

	IWritableShaderSource *s = client->getShaderSource();
	postprocessMat.UseMipMaps = false;
	postprocessMat.ZBuffer = false;
	postprocessMat.ZWriteEnable = false;
	u32 shader = s->getShader("post_processing", TILE_MATERIAL_BASIC);
	postprocessMat.MaterialType = s->getShaderInfo(shader).material;
	postprocessMat.TextureLayer[0].AnisotropicFilter = false;
	postprocessMat.TextureLayer[0].BilinearFilter = false;
	postprocessMat.TextureLayer[0].TrilinearFilter = false;
	postprocessMat.TextureLayer[0].TextureWrapU = video::ETC_CLAMP_TO_EDGE;
	postprocessMat.TextureLayer[0].TextureWrapV = video::ETC_CLAMP_TO_EDGE;
}

void RenderingCorePlain::initTextures()
{
	if (scale <= 1) {
		postprocess = driver->addRenderTargetTexture(
				screensize, "postprocess", video::ECF_A8R8G8B8);
	} else {
		v2u32 size{scaledown(scale, screensize.X), scaledown(scale, screensize.Y)};
		lowres = driver->addRenderTargetTexture(
				size, "render_lowres", video::ECF_A8R8G8B8);
		postprocess = driver->addRenderTargetTexture(
				size, "postprocess", video::ECF_A8R8G8B8);
	}
	postprocessMat.TextureLayer[0].Texture = postprocess;
}

void RenderingCorePlain::clearTextures()
{
	driver->removeTexture(postprocess);
	if (scale <= 1)
		return;
	driver->removeTexture(lowres);
}

void RenderingCorePlain::beforeDraw()
{
	driver->setRenderTarget(postprocess, true, true, skycolor);
}

void RenderingCorePlain::upscale()
{
	driver->setRenderTarget(nullptr, false, false, skycolor);
	v2u32 size{scaledown(scale, screensize.X), scaledown(scale, screensize.Y)};
	v2u32 dest_size{scale * size.X, scale * size.Y};
	driver->draw2DImage(lowres, core::rect<s32>(0, 0, dest_size.X, dest_size.Y),
			core::rect<s32>(0, 0, size.X, size.Y));
}

void RenderingCorePlain::applyPostProcess()
{
	static const video::S3DVertex vertices[4] = {
		video::S3DVertex(1.0, -1.0, 0.0, 0.0, 0.0, -1.0,
				video::SColor(255, 0, 255, 255), 1.0, 0.0),
		video::S3DVertex(-1.0, -1.0, 0.0, 0.0, 0.0, -1.0,
				video::SColor(255, 255, 0, 255), 0.0, 0.0),
		video::S3DVertex(-1.0, 1.0, 0.0, 0.0, 0.0, -1.0,
				video::SColor(255, 255, 255, 0), 0.0, 1.0),
		video::S3DVertex(1.0, 1.0, 0.0, 0.0, 0.0, -1.0,
				video::SColor(255, 255, 255, 255), 1.0, 1.0),
	};
	static const u16 indices[6] = {0, 1, 2, 2, 3, 0};
	driver->setMaterial(postprocessMat);
	driver->drawVertexPrimitiveList(&vertices, 4, &indices, 2);
	if (scale <= 1) {
		driver->setRenderTarget(nullptr, false, false, skycolor);
	} else {
		driver->setRenderTarget(lowres, false, false, skycolor);
	}
	driver->draw2DImage(postprocess, v2s32(0, 0));
}

void RenderingCorePlain::drawAll()
{
	draw3D();
	drawPostFx();
	applyPostProcess();
	if (scale > 1)
		upscale();
	drawHUD();
}
