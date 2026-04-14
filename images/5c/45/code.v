module top_module(
    input Clock, Reset, Set, Enable,
    input [Width-1:0] In,
    output reg [Width-1:0] Out
);parameter Width = 32;
parameter Initial = {Width{1'bx}};
parameter AsyncReset = 0;
parameter AsyncSet = 0;
parameter ResetValue = {Width{1'b0}};
parameter SetValue = {Width{1'b1}};

always @ (posedge Clock) begin
    if (AsyncReset && !Reset) begin
        Out <= ResetValue;
    end else if (AsyncSet && Set) begin
        Out <= SetValue;
    end else if (Reset && Set) begin
        Out <= SetValue;
    end else if (Reset) begin
        Out <= ResetValue;
    end else if (Set) begin
        Out <= SetValue;
    end else if (Enable) begin
        Out <= In;
    end
end

endmodule