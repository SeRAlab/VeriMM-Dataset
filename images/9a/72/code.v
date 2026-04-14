module top_module(
    input CHANNEL_UP,
    input USER_CLK,
    output reg rst_r,
    output reg start_r,
    output reg run_r
);//Control state machine state registers
    always @(posedge USER_CLK)
        if(!CHANNEL_UP) 
        begin
            rst_r       <=  1'b1;
            start_r     <=  1'b0;
            run_r       <=  1'b0;
        end
        else
        begin
            rst_r       <=  1'b0;
            start_r     <=  next_start_c;
            run_r       <=  next_run_c;
        end


    //Nextstate logic
    
    // After reset, send the SCP character to open the infinite 
    // frame 
    assign  next_start_c    =   rst_r;

    
    // After the start state, go to normal operation 
    assign  next_run_c      =   start_r ||
                                run_r;
      
endmodule