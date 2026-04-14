module deserializer (
    input wire clk,
    input wire rst,
    input wire [3:0] din,
    output reg [31:0] dout
);
    reg [2:0] count; // 3-bit counter to count the number of clock cycles
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 32'b0;
            count <= 3'b0;
        end else if (count < 3'd8) begin
            dout <= {dout[27:0], din}; // Shift left and add new data
            count <= count + 3'b1;
        end
    end
endmodule