module shift_register_8bit(
    input clk, 
    input reset, 
    input load, 
    input shift, 
    input [7:0] d, 
    output reg [7:0] q);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= d;
        else if (shift)
            q <= {1'b0, q[7:1]};
    end
endmodule