module shift_register (
    input wire clk,
    input wire rst,
    input wire [1:0] din,
    output reg [1:0] dout
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 2'b00;
        end else begin
            dout <= {dout[0], din[0]}; // Shift left
        end
    end
endmodule