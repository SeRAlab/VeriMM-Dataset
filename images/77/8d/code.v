module fibonacci_lfsr_6bit(
    input clk, 
    input reset, 
    output reg [5:0] lfsr);

    always @(posedge clk or posedge reset) begin
        if (reset)
            lfsr <= 6'b000001;
        else
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[3]};
    end
endmodule