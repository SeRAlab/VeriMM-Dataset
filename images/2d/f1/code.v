module counter_64bit (
    input clk,
    input reset,
    input enable,
    input load,
    input [63:0] load_value,
    output reg [63:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 64'b0;
        end else if (load) begin
            count <= load_value;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule