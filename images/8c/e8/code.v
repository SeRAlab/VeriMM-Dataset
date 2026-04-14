module top_module(
    input clk,
    input reset,
    output reg [7:0] fib
);reg [7:0] shift_reg;
reg [1:0] control;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 2'b01;
        control <= 2'b00;
        fib <= 8'b00000001;
    end else begin
        case (control)
            2'b00: begin
                shift_reg <= {shift_reg[6:0], shift_reg[7]};
                control <= 2'b01;
            end
            2'b01: begin
                shift_reg <= {shift_reg[6:0], shift_reg[7]};
                control <= 2'b10;
            end
            2'b10: begin
                shift_reg <= shift_reg + {shift_reg[6:0], shift_reg[7]};
                control <= 2'b00;
                fib <= shift_reg;
            end
        endcase
    end
end

endmodule