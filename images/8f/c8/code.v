module top_module(
    input UD,
    input CLK,
    input LD,
    input [3:0] D,
    input SI,
    output reg SO,
    output [3:0] Q
);reg [3:0] counter;
reg [3:0] shift_reg;

always @(posedge CLK) begin
    if (UD) begin
        counter <= counter + 1;
    end else begin
        counter <= counter - 1;
    end
    
    if (LD) begin
        shift_reg <= D;
    end else begin
        shift_reg <= {shift_reg[2:0], SI};
    end
end

assign Q = counter + shift_reg;

always @(posedge CLK) begin
    SO <= shift_reg[0];
end

endmodule