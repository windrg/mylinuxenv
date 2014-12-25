" udi.vim
" ver 0.7
"
"
if exists("g:loaded_udisty")
	finish
endif
let g:loaded_udisty = 1

augroup udisty
	au BufRead,BufNewfile *.udi setfiletype udi

	autocmd FileType udi call s:UdiHighlighting()


augroup END

function s:UdiHighlighting()
	"hi def hip_signal_default_color cterm=bold ctermfg=55 ctermbg=white gui=bold guifg=#d7d7ff guibg=white
	hi def hip_signal_default_color cterm=bold ctermfg=231 ctermbg=70 gui=bold guifg=#ffffff guibg=#5faf00
	hi def hip_signal_plain_color ctermfg=white guifg=white
	hi def hip_signal_bold_plain_color cterm=bold ctermfg=white gui=bold guifg=white
	hi def hip_signal_mac_color cterm=bold ctermfg=blue ctermbg=white gui=bold guifg=blue guibg=white
	hi def hip_signal_error_color cterm=bold ctermfg=white ctermbg=red gui=bold guifg=white guibg=red 
	hi def hip_signal_warning_color cterm=bold ctermfg=202 gui=bold guifg=#ff5f00 
	hi def hip_signal_addr_color ctermfg=160 guifg=#d70000 
	hi def hip_signal_debug_color ctermfg=21 guifg=#0000ff 
	hi def hip_signal_mib_color ctermfg=46 guifg=#00ff00
	hi def hip_signal_iface_color ctermfg=46 guifg=#00ff00
	hi def hip_signal_time_color ctermfg=cyan gui=bold guifg=cyan

	"Data Path
	syntax keyword mac ma_packet_cancel_req ma_packet_cfm ma_packet_ind ma_packet_req ma_stream_ind
	highlight link mac hip_signal_mac_color

	"Control Path
	syntax keyword mlme mlme_add_autonomous_scan_cfm mlme_add_autonomous_scan_req mlme_add_multicast_address_cfm mlme_add_multicast_address_req mlme_add_probe_request_cfm mlme_add_probe_request_req mlme_add_template_cfm mlme_add_template_req mlme_add_triggered_get_cfm mlme_add_triggered_get_req mlme_add_tspec_cfm mlme_add_tspec_req mlme_add_vif_cfm mlme_add_vif_req mlme_autonomous_scan_done_ind mlme_autonomous_scan_loss_ind mlme_beacon_listen_start_cfm mlme_beacon_listen_start_req mlme_beacon_listen_stop_cfm mlme_beacon_listen_stop_req mlme_cancel_packet_trigger_cfm mlme_cancel_packet_trigger_req mlme_cancel_prioritise_multicast_cfm mlme_cancel_prioritise_multicast_req mlme_cancel_vif_time_cfm mlme_cancel_vif_time_req mlme_config_channels_cfm mlme_config_channels_req mlme_config_queue_cfm mlme_config_queue_req mlme_connect_status_cfm mlme_connect_status_req mlme_del_autonomous_scan_cfm mlme_del_autonomous_scan_req mlme_deletekeys_cfm mlme_deletekeys_req mlme_del_triggered_get_cfm mlme_del_triggered_get_req mlme_del_tspec_cfm mlme_del_tspec_req mlme_del_vif_cfm mlme_del_vif_req mlme_get_cfm mlme_get_key_sequence_cfm mlme_get_key_sequence_req mlme_get_req mlme_hl_sync_cancel_cfm mlme_hl_sync_cancel_req mlme_hl_sync_cfm mlme_hl_sync_req mlme_modify_bss_parameter_cfm mlme_modify_bss_parameter_req mlme_powermgt_cfm mlme_powermgt_req mlme_reset_cfm mlme_reset_req mlme_service_ind mlme_set_cfm mlme_set_channel_cfm mlme_set_channel_req mlme_set_info_elements_cfm mlme_set_info_elements_req mlme_setkeys_cfm mlme_setkeys_req mlme_set_packet_filter_cfm mlme_set_packet_filter_req mlme_set_req mlme_set_route_cfm mlme_set_route_req mlme_start_aggregation_cfm mlme_start_aggregation_req mlme_start_cfm mlme_start_req mlme_start_txrmc_cfm mlme_start_txrmc_req mlme_stop_aggregation_cfm mlme_stop_aggregation_req mlme_stop_txrmc_cfm mlme_stop_txrmc_req mlme_synchronisation_ind mlme_traffic_info_req mlme_triggered_get_ind
	highlight link mlme hip_signal_default_color

	syntax keyword addr sa ta ra interface_address arp_filter_address sta_address device_address 
	highlight link addr hip_signal_addr_color

	syntax keyword debug debug_generic_cfm debug_generic_ind debug_generic_req debug_message debug_string_ind debug_variable debug_word16_ind debug_words
	highlight link debug hip_signal_debug_color

	syntax keyword mib mib_variable_element mib_variable_identifier mib_variable_status
	highlight link mib hip_signal_mib_color 

	syntax keyword interface virtual_interface_type cloned_virtual_interface_index 
	highlight link interface hip_signal_iface_color

	syntax keyword error invalid_virtual_interface_index mlme_mib_error_ind mlme_blockack_error_ind ma_packet_error_ind 
	highlight link error hip_signal_error_color

	syntax keyword warning too_many_simultaneous_requests qos_excessive_not_ack qos_txop_limit_exceeded qos_unspecified_reason 
	highlight link warning hip_signal_warning_color 

	syntax keyword etc active_mode address adhoc aifs ap association_information autonomous_scan_id availability_duration availability_interval beacon beacon_and_probe_response beacon_period bidirectional bss_already_started_or_joined bssid bss_parameters bt_amp buffer_size capability_information channel_configuration channel_frequency channel_information cipher_suite_selector cl connected_active connection_status contention created data data1 data2 decryption_error default delay deleted direction disconnected dtim_period duration ecwmax ecwmin entries frame_type group group_address group_addressed handle host_tag ie igtk information_elements insufficient_resource interval invalid_information_element invalid_multicast_cipher invalid_parameters invalid_unicast_cipher keep_alive_failure keep_alive_required key key_id key_type legacy_ps length listen_interval local_time management maxcta maxctp mcast_addr medium_time mic_error mincta minctp minimum_data_rate monitor msdu_lifetime nat_keepalive no_temporal_key_available not_supported number_of_multicast_group_addresses opt_in opt_in_sleep opt_out opt_out_sleep packet_control packet_filter_mode pairwise pause pd peerkey peer_qsta_address peer_sta_address power_management_mode power_save priority probe_request_id probe_response ps_scheme qos_up0 qos_up1 qos_up2 qos_up3 qos_up4 qos_up5 qos_up6 qos_up7 qsta_leaving queue_index rate receive received_rate reception_status refused rejected_invalid_group_cipher rejected_invalid_ie rejected_invalid_pairwise_cipher reserved reset_required_before_start result_code resume retry_count routingtable rssi rx_success s_apsd sco sequence_number service service_interval service_start_time snr starting_sequence_number station status success successful timeout traffic_information transmission_control_bitmap transmission_failure transmit transmit_rate triggered_id txop_limit u_apsd unavailable_priority unknown_ba unspecified_failure unspecified_reason unsynchronised updated user_priority virtual_interface_index 
	highlight link etc hip_signal_bold_plain_color

	syntax keyword transmission_status_normal transmission_status successful
	highlight link transmission_status_normal Statement

	syntax keyword transmission_status_abnormal retry_limit tx_lifetime no_bss excessive_data_length unsupported_priority unavailable_key_mapping tx_edca_timeout block_ack_timeout rejected_resource_issue_on_current_vif rejected_peer_station_sleeping rejected_too_many_group_frame_pending rejected_cancelled excessive_tx_failures
	highlight link transmission_status_abnormal hip_signal_error_color


	syntax match comment /\/\/.*/
	highlight link comment Comment

	syntax match timeformat /^\d\{4}\/\d\{2}\/\d\{2}-\d\{2}:\d\{2}:\d\{2}\.\d\{3}/
	highlight link timeformat hip_signal_time_color


	"syntax match macaddr /[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}/
	"highlight link timeformat NonText
endfunction
