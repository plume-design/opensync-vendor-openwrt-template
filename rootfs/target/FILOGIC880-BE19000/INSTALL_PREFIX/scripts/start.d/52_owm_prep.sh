# This depends on 51_owm.sh possibly as it can
# override OWM Node_Services configuration.

ovsh=${INSTALL_PREFIX}/tools/ovsh

owm_wanted() {
    $ovsh s Node_Services \
        -w service==owm \
        -w enable==true \
        -w status==enabled >/dev/null
}

# Legacy driver is only intended for testing, not
# actual use. But since it was designed around
# being able to create interfaces from scratch,
# let it do it. Interface creation is currently
# tied to osw_drv_nl80211 anyway.
is_legacy() {
    test -z "$OSW_DRV_TARGET_DISABLED"
}

is_not_legacy() {
    ! is_legacy
}

create_vap() {
    phy_name=$1
    vif_name=$3
    vif_type=$4

    iw dev $vif_name del
    iw phy $phy_name interface add $vif_name type $vif_type
}

create_vaps() {
    create_vap phy0 1 ra1 __ap
    create_vap phy0 2 ra2 __ap
    create_vap phy1 1 rai1 __ap
    create_vap phy1 2 rai2 __ap
    create_vap phy2 1 rax1 __ap
    create_vap phy2 2 rax2 __ap
    create_vap phy0 3 ra3 __ap
    create_vap phy1 3 rai3 __ap
    create_vap phy2 3 rax3 __ap
    create_vap phy0 4 ra4 __ap
    create_vap phy1 4 rai4 __ap
    create_vap phy2 4 rax4 __ap
    create_vap phy0 5 ra5 __ap
    create_vap phy1 5 rai5 __ap
    create_vap phy2 5 rax5 __ap
    create_vap phy0 6 ra6 __ap
    create_vap phy1 6 rai6 __ap
    create_vap phy2 6 rax6 __ap
    create_vap phy0 7 ra7 __ap
    create_vap phy1 7 rai7 __ap
    create_vap phy2 7 rax7 __ap
}

if owm_wanted && is_not_legacy
then
    create_vaps
fi
