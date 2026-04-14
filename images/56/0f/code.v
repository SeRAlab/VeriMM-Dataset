module top_module(
    
    input       sdram_clk,
    input       sdram_rst_,
    


    
    output  reg PAA = 0,
    output  reg SET_MODE
);parameter
    INIT_CNT        = 16'h4000,
    INIT_HALF_CNT   = INIT_CNT >> 1;
    



reg     [15:0]  init_counter;
wire    init_counter_done;

assign init_counter_done = (init_counter == INIT_CNT);

always @(posedge sdram_clk) begin
    if (!sdram_rst_)
        init_counter <= 'b0;
    else if (!init_counter_done)
        init_counter <= init_counter + 1'b1;
end








        


always @(posedge sdram_clk) begin
        PAA <= init_counter_done;
end        


always @(posedge sdram_clk) begin
        SET_MODE <= 1'b1;
end

        
endmodule