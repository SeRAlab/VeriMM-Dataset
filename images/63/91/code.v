module d_flip_flop(
    input clk,
    input rst,
    input d,
    output reg q);
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0; // Asynchronous reset
        else
            q <= d; // Capture data on rising edge of clock
    end
endmodule