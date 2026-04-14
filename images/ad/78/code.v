module top_module(
    input wave_kc_in,
    input spec_kc_in,
    
    input wave_wea_in,
    
    input search_en_in,
    
    output wire wavegener_wea_out,
    output reg wavegener_state_out = 1'b1,
    
    output wire wavefft_wea_out,
    output reg wavefft_state_out = 1'b1
    );always@(posedge wave_kc_in)
        wavegener_state_out = ~wavegener_state_out;
    assign wavegener_wea_out = wavegener_state_out & wave_wea_in;
    
    always@(posedge spec_kc_in)
        if(search_en_in)
            wavefft_state_out = 1'b0;
        else
            wavefft_state_out = ~wavefft_state_out;
            
    assign wavefft_wea_out = wavefft_state_out & wave_wea_in & (~search_en_in);
endmodule