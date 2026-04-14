module d_ff (
    input wire clk,
    input wire a,
    output reg b
);

    always @(posedge clk) begin
        b <= a;
    end

endmodule