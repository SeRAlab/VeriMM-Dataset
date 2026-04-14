module johnson_counter (
    input clk,
    input reset_n,
    output [2:0] count
);
    reg [2:0] count_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count_reg <= 3'b001;
        else
            count_reg <= {~count_reg[2], count_reg[2:1]};
    end

    assign count = count_reg;

endmodule