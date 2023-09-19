{ config, pkgs, ... }: {
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
      dex
      i3
      networkmanagerapplet
      pango
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
            name = "plasma5";
            start = ''exec env KDEWM=${pkgs.i3}/bin/i3 ${pkgs.plasma-workspace}/bin/startplasma-x11'';
          }
        ];
      };

      desktopManager.plasma5.enable = true;

      windowManager = {
        i3 = {
          enable = true;
          configFile = builtins.toFile "i3.config" ''
            # i3 config file (v4)
            #
            # Please see https://i3wm.org/docs/userguide.html for a complete reference!
            
            set $mod Mod1
            
            # Font for window titles. Will also be used by the bar unless a different font
            # is used in the bar {} block below.
            font pango:monospace 10
            
            # This font is widely installed, provides lots of unicode glyphs, right-to-left
            # text rendering and scalability on retina/hidpi displays (thanks to pango).
            #font pango:DejaVu Sans Mono 8
            
            # Use Mouse+$mod to drag floating windows to their wanted position
            floating_modifier $mod
            
            # start a terminal
            bindsym $mod+Return exec konsole
            
            # kill focused window
            bindsym $mod+Shift+q kill
            
            # krunner launcher
            bindsym $mod+d exec --no-startup-id /run/current-system/sw/bin/qdbus org.kde.krunner /App display
            
            # change focus
            bindsym $mod+h focus left
            bindsym $mod+j focus down
            bindsym $mod+k focus up
            bindsym $mod+l focus right
            
            # alternatively, you can use the cursor keys:
            bindsym $mod+Left focus left
            bindsym $mod+Down focus down
            bindsym $mod+Up focus up
            bindsym $mod+Right focus right
            
            # move focused window
            bindsym $mod+Shift+h move left
            bindsym $mod+Shift+j move down
            bindsym $mod+Shift+k move up
            bindsym $mod+Shift+l move right
            
            # alternatively, you can use the cursor keys:
            bindsym $mod+Shift+Left move left
            bindsym $mod+Shift+Down move down
            bindsym $mod+Shift+Up move up
            bindsym $mod+Shift+Right move right
            
            # split in horizontal orientation
            #bindsym $mod+h split h
            
            # split in vertical orientation
            bindsym $mod+v split v
            
            # enter fullscreen mode for the focused container
            bindsym $mod+f fullscreen toggle
            
            # change container layout (stacked, tabbed, toggle split)
            bindsym $mod+s layout stacking
            bindsym $mod+w layout tabbed
            bindsym $mod+e layout toggle split
            
            # toggle tiling / floating
            bindsym $mod+Shift+space floating toggle
            
            # change focus between tiling / floating windows
            bindsym $mod+space focus mode_toggle
            
            # switch to workspace
            bindsym $mod+1 workspace 1
            bindsym $mod+2 workspace 2
            bindsym $mod+3 workspace 3
            bindsym $mod+4 workspace 4
            bindsym $mod+5 workspace 5
            bindsym $mod+6 workspace 6
            bindsym $mod+7 workspace 7
            bindsym $mod+8 workspace 8
            bindsym $mod+9 workspace 9
            bindsym $mod+0 workspace 10
            
            # move focused container to workspace
            bindsym $mod+Shift+1 move container to workspace 1
            bindsym $mod+Shift+2 move container to workspace 2
            bindsym $mod+Shift+3 move container to workspace 3
            bindsym $mod+Shift+4 move container to workspace 4
            bindsym $mod+Shift+5 move container to workspace 5
            bindsym $mod+Shift+6 move container to workspace 6
            bindsym $mod+Shift+7 move container to workspace 7
            bindsym $mod+Shift+8 move container to workspace 8
            bindsym $mod+Shift+9 move container to workspace 9
            bindsym $mod+Shift+0 move container to workspace 10
            
            # reload the configuration file
            bindsym $mod+Shift+c reload
            # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
            bindsym $mod+Shift+r restart
            
            # resize window (you can also use the mouse for that)
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
            bindsym $mod+r mode "resize"
            
            bindsym $mod+shift+s sticky toggle
            
            bindsym $mod+n exec ~/bin/notifications.sh

            bar {
                mode dock
            }
            
            for_window [class="Slack" floating] move container to workspace current
            
            #####################################
            # Plasma compatibility improvements
            for_window [window_role="pop-up"] floating enable
            for_window [window_role="task_dialog"] floating enable
            for_window [class="yakuake"] floating enable
            for_window [class="systemsettings"] floating enable
            for_window [class="plasmashell"] floating enable;
            for_window [class="Plasma"] floating enable; border none
            for_window [title="plasma-desktop"] floating enable; border none
            for_window [title="win7"] floating enable; border none
            for_window [class="krunner"] floating enable; border none
            for_window [class="Kmix"] floating enable; border none
            for_window [class="Klipper"] floating enable; border none
            for_window [class="Plasmoidviewer"] floating enable; border none
            for_window [class="(?i)*nextcloud*"] floating disable
            for_window [class="plasmashell" window_type="notification"] border none, move right 700px, move down 450px
            no_focus [class="plasmashell" window_type="notification"]
            # kill the desktop
            for_window [title="Desktop — Plasma"] kill; floating enable; border none
            # using plasma's logout screen instead of i3's
            bindsym $mod+Shift+e exec --no-startup-id qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1

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
          '';
        };
      };
    };
  };

  # Plasma 5.25+ uses systemd to start up. To use a WM other than KWin we have
  # to disable kwin's systemd service. See also
  # https://wiki.archlinux.org/title/KDE#Replacing_KWin_service
  systemd.user.services.plasma-kwin_x11.enable = false;
  systemd.user.services.plasma-i3 = {
    enable = true;
    description = "plasma-i3";

    wantedBy = ["plasma-workspace.target"];
    before = ["plasma-workspace.target"];

    serviceConfig               = {
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

  #xdg.portal.extraPortals = [ xdg-desktop-portal-kde ];
}
