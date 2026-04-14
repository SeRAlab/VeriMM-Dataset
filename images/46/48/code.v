module top_module(
    input wire clk,
    input wire rst,
    input wire [3:0] in,
    output wire [3:0] out
);reg [3:0] temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp <= 4'b0;
        end else begin
            if (in[0] == 1) begin
                temp <= in * 2;
            end else begin
                temp <= in / 2;
            end
        end
    end

    assign out = temp;

endmodule