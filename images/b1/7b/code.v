module binary_counter (
    input clk,
    input rst,
    input en,
    input load,
    input [15:0] preset_value,
    output reg [15:0] count);

    always @(posedge clk) begin
        if (rst) begin
            count <= 16'b0;
        end else if (load) begin
            count <= preset_value;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule