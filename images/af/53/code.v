module parallel_load_register (
    input [3:0] d,
    input clk,
    input load,
    output [3:0] q
);

    reg [3:0] q_reg;

    always @(posedge clk) begin
        if (load) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule