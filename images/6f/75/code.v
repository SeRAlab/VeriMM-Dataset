module top_module(
    input CLK,
    input RESET,
    output reg Q1,
    output reg Q0
);reg [1:0] count_reg;
reg [1:0] next_count_reg;

always @(posedge CLK) begin
    if(RESET) begin
        count_reg <= 2'b00;
    end
    else begin
        count_reg <= next_count_reg;
    end
end

always @(*) begin
    case(count_reg)
        2'b00: next_count_reg = 2'b01;
        2'b01: next_count_reg = 2'b10;
        2'b10: next_count_reg = 2'b11;
        2'b11: next_count_reg = 2'b00;
    endcase
end

assign Q1 = count_reg[1];
assign Q0 = count_reg[0];

endmodule