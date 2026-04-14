module shift_register_16bit (
    input clk,
    input reset,
    input [15:0] parallel_in,
    input load,
    output reg [15:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 16'b0;
    else if (load)
        q <= parallel_in;
    else
        q <= {q[14:0], 1'b0};
    end
    
endmodule