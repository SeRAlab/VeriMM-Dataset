module binary_counter(
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [3:0] data,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= data;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule