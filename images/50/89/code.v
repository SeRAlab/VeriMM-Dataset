module johnson_counter(
    input clk,
    input rst_n,
    output reg [3:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 4'b0000;
        end else begin
            count <= {count[2:0], ~count[3]};
        end
    end
endmodule