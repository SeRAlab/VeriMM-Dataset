module top_module(
    input wire clk,
    input wire rst,
    input wire [3:0] in,
    output reg [1:0] out
);reg [3:0] constant = 4'b1010;
reg [2:0] counter = 3'b0;

always @(posedge clk) begin
    if (rst) begin
        out <= 2'b00;
        counter <= 3'b0;
    end else begin
        if (counter == 3'b111) begin
            out <= 2'b00;
            counter <= 3'b0;
        end else begin
            out <= in + constant;
            counter <= counter + 1;
        end
    end
end

endmodule