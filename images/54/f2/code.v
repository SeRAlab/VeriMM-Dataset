module top_module(
    input clk,
    input reset,
    output reg out
);reg [1:0] state;
always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out <= 0;
    end else begin
        case (state)
            2'b00: begin
                out <= 0;
                state <= 2'b01;
            end
            2'b01: begin
                out <= 1;
                state <= 2'b10;
            end
            2'b10: begin
                out <= 1;
                state <= 2'b11;
            end
            2'b11: begin
                out <= 0;
                state <= 2'b00;
            end
        endcase
    end
end

endmodule