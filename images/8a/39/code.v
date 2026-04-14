module top_module(
    input clk,
    input reset,
    output reg [3:0] out
);reg [3:0] state = 4'b0000;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
        out <= 4'b0000;
    end else begin
        case (state)
            4'b0000: begin
                state <= 4'b0001;
                out <= 4'b0000;
            end
            4'b0001: begin
                state <= 4'b0010;
                out <= 4'b0001;
            end
            4'b0010: begin
                state <= 4'b0011;
                out <= 4'b0010;
            end
            4'b0011: begin
                state <= 4'b0100;
                out <= 4'b0011;
            end
            4'b0100: begin
                state <= 4'b0101;
                out <= 4'b0100;
            end
            4'b0101: begin
                state <= 4'b0110;
                out <= 4'b0101;
            end
            4'b0110: begin
                state <= 4'b0111;
                out <= 4'b0110;
            end
            4'b0111: begin
                state <= 4'b1000;
                out <= 4'b0111;
            end
            4'b1000: begin
                state <= 4'b0000;
                out <= 4'b1000;
            end
        endcase
    end
end

endmodule