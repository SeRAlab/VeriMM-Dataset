module enable_load_counter(
    input clk,
    input rst_n,
    input enable,
    input load,
    input [3:0] data,
    output reg [3:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= data;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule