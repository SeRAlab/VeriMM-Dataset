module top_module(
    input Clock,
    input Reset,
    input Set,
    input Enable,
    input [Width-1:0] In,
    output reg [Width-1:0] Out
);parameter Width = 32;
parameter Initial = {Width{1'bx}};
parameter AsyncReset = 0;
parameter AsyncSet = 0;
parameter ResetValue = {Width{1'b0}};
parameter SetValue = {Width{1'b1}};

reg [Width-1:0] reg_out;

always @(posedge Clock) begin
    if (AsyncReset && !AsyncSet) begin
        if (Reset) reg_out <= ResetValue;
        else if (Enable) reg_out <= In;
    end else if (!AsyncReset && AsyncSet) begin
        if (Set) reg_out <= SetValue;
        else if (Enable) reg_out <= In;
    end else if (AsyncReset && AsyncSet) begin
        if (Reset) reg_out <= ResetValue;
        else if (Set) reg_out <= SetValue;
        else if (Enable) reg_out <= In;
    end else begin
        if (Reset) reg_out <= ResetValue;
        else if (Set) reg_out <= SetValue;
        else if (Enable) reg_out <= In;
    end
end

assign Out = reg_out;

endmodule