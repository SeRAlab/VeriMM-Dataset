module top_module(A, B, C, Y, OVF);input [3:0] A, B;
input C;
output reg [3:0] Y; // Change output to reg since we need to assign values inside always block
output reg OVF;     // Change output to reg since we need to assign values inside always block

reg [3:0] sum;
reg [3:0] diff;

// Calculate the sum and difference
always @ (A, B, C)
begin
    if (C == 0) // Add
    begin
        sum = A + B;
        diff = 4'b0;
    end
    else // Subtract
    begin
        sum = 4'b0;
        diff = A - B;
    end
end

// Calculate the output and overflow
always @ (sum, diff)
begin
    if (sum > 4'b1111) // Overflow
    begin
        Y = 4'b1111;
        OVF = 1;
    end
    else if (diff < 4'b0000) // Underflow
    begin
        Y = 4'b0000;
        OVF = 1;
    end
    else // Normal output
    begin
        Y = (C == 0) ? sum : diff;
        OVF = 0;
    end
end

endmodule