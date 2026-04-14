module register(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [7:0] din,
    output reg [7:0] dout
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dout <= 8'b0;
    end else if (we) begin
        dout <= din;
    end
end

endmodule