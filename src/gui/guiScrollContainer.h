/*
Minetest
Copyright (C) 2020 DS

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

#pragma once

#include "irrlichttypes_extrabloated.h"
#include "util/string.h"
#include "guiScrollBar.h"

class GUIScrollContainer : public gui::IGUIElement
{
public:
	GUIScrollContainer(gui::IGUIEnvironment *env, gui::IGUIElement *parent, s32 id,
			const core::rect<s32> &rectangle, const std::string &orientation,
			f32 scrollfactor);

	virtual bool OnEvent(const SEvent &event) override;

	virtual void draw() override;

	inline void onScrollEvent(gui::IGUIElement *caller)
	{
		if (caller == m_scrollbar)
			updateScrolling();
	}

	inline void setScrollBar(GUIScrollBar *scrollbar)
	{
		m_scrollbar = scrollbar;
		updateScrolling();
	}

	inline void resetStartingVector() {
		m_has_starting_vector = false;
	}

	inline void setStartingVector(const v2s32 &vec) {
		m_has_starting_vector = true;
		m_starting_upper_left_corner = getRelativePosition().UpperLeftCorner;
		m_starting_vector = vec;
	}

	void setScrollFromVector(const v2s32 &vec);

	const c8 *getTypeName() const override {
		return "GUIScrollContainer";
	}

private:
	enum OrientationEnum
	{
		VERTICAL,
		HORIZONTAL,
		UNDEFINED
	};

	GUIScrollBar *m_scrollbar;
	OrientationEnum m_orientation;
	f32 m_scrollfactor;

	bool m_has_starting_vector = false;
	v2s32 m_starting_upper_left_corner;
	v2s32 m_starting_vector;

	void updateScrolling();
};
