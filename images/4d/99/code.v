module shift_reg_3bit (
    input wire clk,
    input wire serial_in,
    output reg [2:0] Q
    );

always @(posedge clk) begin
    Q <= {Q[1:0], serial_in};
end

endmodule