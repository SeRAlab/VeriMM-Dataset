module shift_register_3bit(
    input clk,
    input d,
    
    output reg [2:0] q
);
    always @(posedge clk) begin
        q <= {q[1:0], d};
    end
endmodule