module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [7:0] data,
    output reg [7:0] q,
    output reg [7:0] parallel_out);reg [7:0] shift_reg;
    reg [7:0] parallel_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 8'b0;
            parallel_reg <= 8'b0;
        end
        else begin
            if (ena) begin
                shift_reg <= {shift_reg[6:0], data};
            end
            else if (load) begin
                shift_reg <= data;
            end
            parallel_reg <= shift_reg;
        end
    end

    assign q = shift_reg[7:0];
    assign parallel_out = parallel_reg[7:0];

endmodule