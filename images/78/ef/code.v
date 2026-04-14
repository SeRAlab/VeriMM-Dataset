module sync_binary_counter (
    input clk,
    input rst,
    input en,
    input load,
    input [7:0] init_value,
    output reg [7:0] count);

    always @(posedge clk) begin
        if (rst) begin
            count <= 8'b0;
        end else if (load) begin
            count <= init_value;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule