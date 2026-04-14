module loadable_counter(
    input clk,
    input rst_n,
    input load,
    input [31:0] load_val,
    output reg [31:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 32'b0;
        end else if (load) begin
            count <= load_val;
        end else begin
            count <= count + 1;
        end
    end
endmodule