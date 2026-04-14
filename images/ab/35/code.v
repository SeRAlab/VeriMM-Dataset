module top_module(
    input clk,
    input reset,
    input up_down,
    input load,
    input [3:0] load_data,
    output reg [3:0] count
);always @(posedge clk or negedge reset) begin
        if (!reset) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= load_data;
        end else if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule