module top_module(
    input clk,
    input reset,
    input [3:0] shift_in,
    input shift_load,
    input up_down,
    input count_enable,
    output reg [3:0] count,
    output reg max_reached,  // Changed to reg to allow assignment in always block
    output [7:0] result
);reg [3:0] shift_reg;
reg [3:0] count_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 0;
        count_reg <= 0;
        max_reached <= 0;  // Initialize max_reached on reset
    end else begin
        if (shift_load) begin
            shift_reg <= shift_in;
        end else begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end
        
        if (count_enable) begin
            if (up_down) begin
                if (count_reg == 4'b1111) begin
                    count_reg <= 4'b0000;
                    max_reached <= 1;
                end else begin
                    count_reg <= count_reg + 1;
                    max_reached <= 0;
                end
            end else begin
                if (count_reg == 4'b0000) begin
                    count_reg <= 4'b1111;
                    max_reached <= 1;
                end else begin
                    count_reg <= count_reg - 1;
                    max_reached <= 0;
                end
            end
        end
    end
end

assign result = shift_reg + count_reg;

endmodule