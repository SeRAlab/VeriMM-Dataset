module simple_des (
    input wire clk,
    input wire reset,
    input wire [63:0] data_in,
    input wire [63:0] key,
    output reg [63:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 64'b0;
        end else begin
            data_out <= data_in ^ key; // Simplified encryption
        end
    end
endmodule