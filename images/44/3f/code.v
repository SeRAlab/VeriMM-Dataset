module ShiftRegister8bit (
    input clk,
    input rst_n,
    input load,
    input [7:0] in,
    output reg [7:0] out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 8'b00000000;
        end else if (load) begin
            out <= in;
        end else begin
            out <= {1'b0, out[7:1]};
        end
    end
endmodule