module shift_register_8bit(
    input clk, reset,
    input [7:0] d,
    output reg [7:0] q);
    
    always @(posedge clk) begin
        if (reset) 
            q <= 8'b0;
        else 
            q <= {q[6:0], d[7]};
    end
endmodule