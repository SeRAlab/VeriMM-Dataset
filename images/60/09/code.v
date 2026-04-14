module top_module(
    input clk,
    input reset,
    input serial_data,
    input [7:0] parallel_data,
    output reg match
);reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
        match <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], serial_data};
        if (shift_reg == parallel_data) begin
            match <= 1'b1;
        end else begin
            match <= 1'b0;
        end
    end
end

endmodule