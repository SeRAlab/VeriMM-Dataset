module shift_register(
    input        clk,
    input        reset,
    input        load,
    input        data_in,
    input  [3:0] parallel_in,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 4'b0000;
    end else if (load) begin
        q_reg <= parallel_in;
    end else begin
        q_reg <= {data_in, q_reg[3:1]};
    end
end

assign q = q_reg;

endmodule