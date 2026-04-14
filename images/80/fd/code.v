module top_module(
    input clk,
    output reg VPB,
    output reg VNB
);reg [1:0] state;

always @(posedge clk) begin
    case(state)
        2'b00: begin
            VPB <= 1;
            VNB <= 0;
            state <= 2'b01;
        end
        2'b01: begin
            VPB <= 0;
            VNB <= 1;
            state <= 2'b10;
        end
        2'b10: begin
            VPB <= 1;
            VNB <= 0;
            state <= 2'b11;
        end
        2'b11: begin
            VPB <= 0;
            VNB <= 1;
            state <= 2'b00;
        end
    endcase
end

endmodule