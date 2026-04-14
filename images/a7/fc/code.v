module top_module(
    clock,
    reset,
    enable,
    dout,
    dout_next
);parameter LENGTH = 6;
    parameter FULL_CYCLE = 1;
    
    input                   clock;
    input                   reset;
    input                   enable;
    output    [LENGTH-1: 0] dout;
    output    [LENGTH-1: 0] dout_next;
    
    
    reg       [LENGTH-1: 0] dout;
    
    
    wire                    din;
    wire                    lockup;

    
    assign dout_next = {dout[LENGTH-2:0], din};
    
    
    generate
        if (LENGTH == 3 || LENGTH == 4 || LENGTH == 6 || LENGTH == 7)
            assign din = dout[LENGTH-1] ^ dout[LENGTH-2] ^ lockup;
        else if (LENGTH == 5)
            assign din = dout[4] ^ dout[2] ^ lockup;
        else if (LENGTH == 8)
            assign din = dout[7] ^ dout[5] ^ dout[4] ^ dout[3] ^ lockup;
        else if (LENGTH == 9)
            assign din = dout[8] ^ dout[4] ^ lockup;
        else
        begin
            
            assign din = dout[0];
        end
        
        
        if (FULL_CYCLE == 1)
            assign lockup = ~|(dout[LENGTH-2:0]);
        else
            assign lockup = 1'b0;
    endgenerate
   
    always @(posedge clock)
    begin
        if (reset)
            dout <= {(LENGTH){1'b1}};
        else if (enable)
            dout <= dout_next;
    end
endmodule