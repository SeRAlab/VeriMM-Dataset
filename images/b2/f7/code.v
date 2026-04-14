module Register5bit (
    input clk,
    input clr,
    input load,
    input [4:0] in,
    output reg [4:0] out
);

    always @(posedge clk or posedge clr) begin
        if (clr) begin
            out <= 5'b00000;
        end else if (load) begin
            out <= in;
        end
    end
endmodule