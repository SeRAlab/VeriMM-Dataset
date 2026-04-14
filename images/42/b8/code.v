module shift_register (
    input clk,
    input rst,
    input shift_dir,
    input [7:0] in,
    output reg [7:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 8'd0;
        end else if (shift_dir) begin
            out <= {in[0], in[7:1]};
        end else begin
            out <= {in[6:0], in[7]};
        end
    end

endmodule