{ config, lib, pkgs, ... }: {
  imports = [
    #./qt-style.nix
    ../services/networkmanager.nix
  ];

  # Exclude MATE themes. Yaru will be used instead.
  # Don't install mate-netbook or caja-dropbox
  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa # media player
    ];
    ## Add some packages to complete the desktop
    systemPackages = with pkgs; [
      i3
      networkmanagerapplet
    ];
  };

  ## Enable some programs to provide a complete desktop
  #programs = {
  #  nm-applet.enable = true;
  #  system-config-printer.enable = true;
  #};

  # Enable services to round out the desktop
  services = {
    system-config-printer.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
        defaultSession = "plasma5+i3";
        session = [
          {
            manage = "desktop";
            name = "plasma5+i3";
            start = ''exec env KDEWM=${pkgs.i3}/bin/i3 ${pkgs.plasma-workspace}/bin/startplasma-x11'';
          }
        ];
      };

      desktopManager = {
        plasma5.enable = true;
      };


      windowManager = {
        i3 = {
          enable = true;
          config = {
            modifier = "Mod1";
            terminal = "${pkgs.konsole}/bin/konsole";
          }
          #configFile = builtins.toFile "i3.config" ''
          #  # i3 config file (v4)
          #  #
          #  # Please see https://i3wm.org/docs/userguide.html for a complete reference!
          #  
          #  set $mod Mod1
          #  
          #  # Font for window titles. Will also be used by the bar unless a different font
          #  # is used in the bar {} block below.
          #  font pango:monospace 10
          #  
          #  # This font is widely installed, provides lots of unicode glyphs, right-to-left
          #  # text rendering and scalability on retina/hidpi displays (thanks to pango).
          #  #font pango:DejaVu Sans Mono 8
          #  
          #  # Before i3 v4.8, we used to recommend this one as the default:
          #  # font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
          #  # The font above is very space-efficient, that is, it looks good, sharp and
          #  # clear in small sizes. However, its unicode glyph coverage is limited, the old
          #  # X core fonts rendering does not support right-to-left and this being a bitmap
          #  # font, it doesn’t scale on retina/hidpi displays.
          #  
          #  # Use Mouse+$mod to drag floating windows to their wanted position
          #  floating_modifier $mod
          #  
          #  # start a terminal
          #  bindsym $mod+Return exec konsole
          #  
          #  # kill focused window
          #  bindsym $mod+Shift+q kill
          #  
          #  # start dmenu (a program launcher)
          #  #bindsym $mod+d exec dmenu_run
          #  bindsym $mod+d exec rofi -show run
          #  # There also is the (new) i3-dmenu-desktop which only displays applications
          #  # shipping a .desktop file. It is a wrapper around dmenu, so you need that
          #  # installed.
          #  # bindsym $mod+d exec --no-startup-id i3-dmenu-desktop
          #  
          #  # change focus
          #  bindsym $mod+h focus left
          #  bindsym $mod+j focus down
          #  bindsym $mod+k focus up
          #  bindsym $mod+l focus right
          #  
          #  # alternatively, you can use the cursor keys:
          #  bindsym $mod+Left focus left
          #  bindsym $mod+Down focus down
          #  bindsym $mod+Up focus up
          #  bindsym $mod+Right focus right
          #  
          #  # move focused window
          #  bindsym $mod+Shift+h move left
          #  bindsym $mod+Shift+j move down
          #  bindsym $mod+Shift+k move up
          #  bindsym $mod+Shift+l move right
          #  
          #  # alternatively, you can use the cursor keys:
          #  bindsym $mod+Shift+Left move left
          #  bindsym $mod+Shift+Down move down
          #  bindsym $mod+Shift+Up move up
          #  bindsym $mod+Shift+Right move right
          #  
          #  # split in horizontal orientation
          #  #bindsym $mod+h split h
          #  
          #  # split in vertical orientation
          #  bindsym $mod+v split v
          #  
          #  # enter fullscreen mode for the focused container
          #  bindsym $mod+f fullscreen toggle
          #  
          #  # change container layout (stacked, tabbed, toggle split)
          #  bindsym $mod+s layout stacking
          #  bindsym $mod+w layout tabbed
          #  bindsym $mod+e layout toggle split
          #  
          #  # toggle tiling / floating
          #  bindsym $mod+Shift+space floating toggle
          #  
          #  # change focus between tiling / floating windows
          #  bindsym $mod+space focus mode_toggle
          #  
          #  # focus the parent container
          #  bindsym $mod+a focus parent
          #  
          #  # focus the child container
          #  #bindsym $mod+d focus child
          #  
          #  # switch to workspace
          #  bindsym $mod+1 workspace 1
          #  bindsym $mod+2 workspace 2
          #  bindsym $mod+3 workspace 3
          #  bindsym $mod+4 workspace 4
          #  bindsym $mod+5 workspace 5
          #  bindsym $mod+6 workspace 6
          #  bindsym $mod+7 workspace 7
          #  bindsym $mod+8 workspace 8
          #  bindsym $mod+9 workspace 9
          #  bindsym $mod+0 workspace 10
          #  
          #  # move focused container to workspace
          #  bindsym $mod+Shift+1 move container to workspace 1
          #  bindsym $mod+Shift+2 move container to workspace 2
          #  bindsym $mod+Shift+3 move container to workspace 3
          #  bindsym $mod+Shift+4 move container to workspace 4
          #  bindsym $mod+Shift+5 move container to workspace 5
          #  bindsym $mod+Shift+6 move container to workspace 6
          #  bindsym $mod+Shift+7 move container to workspace 7
          #  bindsym $mod+Shift+8 move container to workspace 8
          #  bindsym $mod+Shift+9 move container to workspace 9
          #  bindsym $mod+Shift+0 move container to workspace 10
          #  
          #  # reload the configuration file
          #  bindsym $mod+Shift+c reload
          #  # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
          #  bindsym $mod+Shift+r restart
          #  # exit i3 (logs you out of your X session)
          #  #bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"
          #  
          #  # resize window (you can also use the mouse for that)
          #  mode "resize" {
          #          # These bindings trigger as soon as you enter the resize mode
          #  
          #          # Pressing left will shrink the window’s width.
          #          # Pressing right will grow the window’s width.
          #          # Pressing up will shrink the window’s height.
          #          # Pressing down will grow the window’s height.
          #          bindsym h resize grow width 10 px or 10 ppt
          #          bindsym k resize grow height 10 px or 10 ppt
          #          bindsym j resize shrink height 10 px or 10 ppt
          #          bindsym l resize shrink width 10 px or 10 ppt
          #  
          #          # same bindings, but for the arrow keys
          #          bindsym Left resize shrink width 10 px or 10 ppt
          #          bindsym Down resize grow height 10 px or 10 ppt
          #          bindsym Up resize shrink height 10 px or 10 ppt
          #          bindsym Right resize grow width 10 px or 10 ppt
          #  
          #          # back to normal: Enter or Escape
          #          bindsym Return mode "default"
          #          bindsym Escape mode "default"
          #  }
          #  bindsym $mod+r mode "resize"
          #  
          #  bindsym $mod+shift+s sticky toggle
          #  
          #  ## Start i3bar to display a workspace bar (plus the system information i3status
          #  ## finds out, if available)
          #  #bar {
          #  ##        status_command i3status
          #  #    status_command SCRIPT_DIR=~/.config/i3blocks i3blocks
          #  #    #font pango:DejaVu Sans Mono 14
          #  #    font pango:monospace 12
          #  #}
          #  
          #  #exec /usr/bin/vmware-user
          #  #
          #  exec --no-startup-id deadd-notification-center
          #  #exec --no-startup-id compton --config ~/.config/compton.conf -b
          #  
          #  bindsym $mod+n exec ~/bin/notifications.sh
          #  
          #  for_window [class="Slack" floating] move container to workspace current
          #  
          #  #####################################
          #  # Plasma compatibility improvements
          #  for_window [window_role="pop-up"] floating enable
          #  for_window [window_role="task_dialog"] floating enable
          #  for_window [class="yakuake"] floating enable
          #  for_window [class="systemsettings"] floating enable
          #  for_window [class="plasmashell"] floating enable;
          #  for_window [class="Plasma"] floating enable; border none
          #  for_window [title="plasma-desktop"] floating enable; border none
          #  for_window [title="win7"] floating enable; border none
          #  for_window [class="krunner"] floating enable; border none
          #  for_window [class="Kmix"] floating enable; border none
          #  for_window [class="Klipper"] floating enable; border none
          #  for_window [class="Plasmoidviewer"] floating enable; border none
          #  for_window [class="(?i)*nextcloud*"] floating disable
          #  for_window [class="plasmashell" window_type="notification"] border none, move right 700px, move down 450px
          #  no_focus [class="plasmashell" window_type="notification"]
          #  # kill the desktop
          #  for_window [title="Desktop — Plasma"] kill; floating enable; border none
          #  # using plasma's logout screen instead of i3's
          #  bindsym $mod+Shift+e exec --no-startup-id qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1
          #  # Kill the bar
          #  bar {
          #      mode hide
          #  }

          #  for_window [title="Desktop — Plasma"] kill, floating enable, border none
          #  for_window [class="plasmashell"] floating enable
          #  for_window [class="Plasma"] floating enable, border none
          #  for_window [title="plasma-desktop"] floating enable, border none
          #  for_window [title="win7"] floating enable, border none
          #  for_window [class="krunner"] floating enable, border none
          #  for_window [class="Kmix"] floating enable, border none
          #  for_window [class="Klipper"] floating enable, border none
          #  for_window [class="Plasmoidviewer"] floating enable, border none
          #  for_window [class="(?i)*nextcloud*"] floating disable
          #  for_window [class="plasmashell" window_type="notification"] floating enable, border none, move right 700px, move down 450px
          #  no_focus [class="plasmashell" window_type="notification"] 
          #'';
        };
      };
    };
  };

  systemd.user.services.plasma-i3 = {
    enable = true;
    description = "plasma-i3";

    wantedBy = ["plasma-workspace.target"];
    before = ["plasma-workspace.target"];

    serviceConfig               = {
      #Type      = "forking";
      #ExecStart = "exec ${pkgs.i3}/bin/i3";
      #ExecStart = "${pkgs.i3}/bin/i3";

      # Somehow this used to work w/o this. Then all of the sudden it stopped
      # and I have no idea why, but I also don't know why it worked before
      # either.
      # https://github.com/NixOS/nixpkgs/issues/7329
      #ExecStart = "${pkgs.bash}/bin/bash -c 'source ${config.system.build.setEnvironment}; ${pkgs.i3}/bin/i3'";
      ExecStart = "${pkgs.bash}/bin/bash -c 'source ${config.system.build.setEnvironment}; exec ${pkgs.i3}/bin/i3'";
      Slice     = "session.slice";
      Restart   = "on-failure";
    };

    path = [
      pkgs.i3
      pkgs.networkmanagerapplet
    ];

    #environment = {
    #};
  };

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = "Mod1";
      terminal = "${pkgs.konsole}/bin/konsole";

      keybindings = let
        modifier = config.xsession.windowManager.i3.config.modifier;
      in lib.mkOptionDefault {
        #"${modifier}+Shift+q" = "kill";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+Shift+greater" = "move workspace to output next";
        #"${modifier}+Ctrl+greater = "move workspace to output next";
        #bindsym $mod+Shift+greater move container to output right
        #bindsym $mod+Shift+less move container to output left

        "${modifier}+Shift+s" = "sticky toggle";
        "${modifier}+Shift+e" = "exec --no-startup-id /run/current-system/sw/bin/qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1";
        # Disabled to see if this fixes some instability in KDE plasmashell where it would lockup and could not be killed/restarted
        "${modifier}+d" = "exec --no-startup-id /run/current-system/sw/bin/qdbus org.kde.krunner /App display";
      };

      window.commands = [
        {
          command = "move container to workspace current";
          criteria = { class = "Slack"; floating = true; };
        }
      ];
    };
    extraConfig = ''
      mode "resize" {
              # These bindings trigger as soon as you enter the resize mode
      
              # Pressing left will shrink the window’s width.
              # Pressing right will grow the window’s width.
              # Pressing up will shrink the window’s height.
              # Pressing down will grow the window’s height.
              bindsym h resize grow width 10 px or 10 ppt
              bindsym k resize grow height 10 px or 10 ppt
              bindsym j resize shrink height 10 px or 10 ppt
              bindsym l resize shrink width 10 px or 10 ppt
      
              # same bindings, but for the arrow keys
              bindsym Left resize shrink width 10 px or 10 ppt
              bindsym Down resize grow height 10 px or 10 ppt
              bindsym Up resize shrink height 10 px or 10 ppt
              bindsym Right resize grow width 10 px or 10 ppt
      
              # back to normal: Enter or Escape
              bindsym Return mode "default"
              bindsym Escape mode "default"
      }

      # https://github.com/heckelson/i3-and-kde-plasma
      bindsym XF86AudioRaiseVolume exec --no-startup-id /run/current-system/sw/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "increase_volume"
      bindsym XF86AudioLowerVolume exec --no-startup-id /run/current-system/sw/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "decrease_volume"
      bindsym XF86AudioMute exec --no-startup-id /run/current-system/sw/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "mute"
      bindsym XF86AudioMicMute exec --no-startup-id /run/current-system/sw/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "mic_mute"


      # Documented in KDE knowledge base
      # TRACE - don't kill the desktop so we can add panel's as needed
      # The big drawback is the desktop initially takes over the whole
      # screen so you have to alt+right-mouse-click to shrink it.
      #for_window [title="Desktop — Plasma"] kill, floating enable, border none
      for_window [title="Desktop — Plasma"] floating enable, border none
      for_window [class="plasmashell"] floating enable
      for_window [class="Plasma"] floating enable, border none
      for_window [title="plasma-desktop"] floating enable, border none
      for_window [title="win7"] floating enable, border none
      for_window [class="krunner"] floating enable, border none
      for_window [class="Kmix"] floating enable, border none
      for_window [class="Klipper"] floating enable, border none
      for_window [class="Plasmoidviewer"] floating enable, border none
      for_window [class="(?i)*nextcloud*"] floating disable
      for_window [class="plasmashell" window_type="notification"] floating enable, border none, move right 700px, move down 450px
      no_focus [class="plasmashell" window_type="notification"] 
      #
      # Custom ones
      #
      # Uncomment if this works better. Otherwise trying the documented one above.
      #for_window [class="plasmashell" window_type="notification"] border none, move right 700px, move down 450px
      for_window [window_role="pop-up"] floating enable
      for_window [window_role="task_dialog"] floating enable
      for_window [class="yakuake"] floating enable
      for_window [class="systemsettings"] floating enable
      no_focus [class="plasmashell" window_type="notification"]
      # Kill the bar
      bar {
          mode hide
      }

    '';
  };

  #xdg.portal.extraPortals = [ xdg-desktop-portal-kde ];
}
