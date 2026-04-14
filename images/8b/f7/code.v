module binary_counter (
    input clk,
    input rst,
    output reg [9:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 10'd0;
        end else begin
            count <= count + 1;
        end
    end

endmodule