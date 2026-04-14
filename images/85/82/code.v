module top_module(
    input CLOCK_IN,
    input RESET,
    input [2:0] SWITCH,
    output reg [3:0] LED
);always @(posedge CLOCK_IN) begin
    if(RESET) begin
        LED <= 4'b0000;
    end
    else begin
        case(SWITCH)
            3'b000: LED <= 4'b0001;
            3'b001: LED <= 4'b0010;
            3'b010: LED <= 4'b0100;
            3'b011: LED <= 4'b1000;
            default: LED <= 4'b1111;
        endcase
    end
end

always @(posedge CLOCK_IN) begin
    LED <= ~LED;
end

endmodule