module binary_counter(
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0] data_in,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'd0;
        end else if (load) begin
            count <= data_in;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule