from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class candycane(ColorScheme):
    progress_bar_color = 1

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                fg = 4
                bg = 15
            if context.border:
                fg = 4
            if context.image:
                fg = 4
            if context.video:
                fg = 4
            if context.audio:
                fg = 4
            if context.document:
                fg = 2
            if context.container:
                attr |= bold
                fg = 4
            if context.directory:
                fg = 3 
            
                
            elif context.executable and not \
                    any((context.media, context.container,
                       context.fifo, context.socket)):
                attr |= bold
                fg = 2
            if context.socket:
                fg = 3
                
            if context.fifo or context.device:
                fg = 3
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and 3 or 4
                bg = 8
            if context.bad:
                fg = 3
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (3, 4):
                    fg = 3
                else:
                    fg = 3
            if not context.selected and (context.cut or context.copied):
                fg = 15
                bg = 8
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 8
            if context.badinfo:
                if attr & reverse:
                    bg = 3
                else:
                    fg = 2

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = context.bad and 8 or 1
            elif context.directory:
                fg = 4
            elif context.tab:
                if context.good:
                    fg = 2
            elif context.link:
                fg = 4 

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 0
                elif context.bad:
                    fg = 4
            if context.marked:
                attr |= bold | reverse
                fg = 2
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 10
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 10
                attr &= ~bold
            if context.vcscommit:
                fg = 5
                attr &= ~bold


        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 8

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color


        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 1
            elif context.vcschanged:
                fg = 2
            elif context.vcsunknown:
                fg = 3
            elif context.vcsstaged:
                fg = 4
            elif context.vcssync:
                fg = 5
            elif context.vcsignored:
                fg = 6

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = 12
            elif context.vcsbehind:
                fg = 13
            elif context.vcsahead:
                fg = 9
            elif context.vcsdiverged:
                fg = 10
            elif context.vcsunknown:
                fg = 11

        return fg, bg, attr
