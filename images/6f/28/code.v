module top_module(
    input clk,
    input reset,
    input [31:0] datain,
    input EscrReg,
    output reg [31:0] data1,
    output reg [31:0] data2
);reg [5:0] RegLe1;
reg [5:0] RegLe2;
reg [5:0] RegEscr;
reg [31:0] balance;

always @(posedge clk) begin
    if (reset) begin
        RegLe1 <= 6'b000000;
        RegLe2 <= 6'b000000;
        RegEscr <= 6'b000000;
        balance <= 0;
    end else begin
        // calculate new balance
        if (EscrReg) begin
            balance <= balance - datain - {26'b0, RegEscr};
        end else begin
            balance <= balance + datain + {26'b0, RegEscr};
        end
        
        // update registers
        RegLe1 <= RegLe2;
        RegLe2 <= balance[5:0];
        RegEscr <= datain[5:0];
    end
end

assign data1 = balance;
assign data2 = {26'b0, RegLe1};

endmodule