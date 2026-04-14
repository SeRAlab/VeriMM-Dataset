module top_module(
    input [3:0] A,
    input [3:0] B,
    input S,
    input C,
    output reg [3:0] F,     // Change to reg
    output reg C_out        // Change to reg
);reg [4:0] temp;  // Declare temp as 5 bits to accommodate for carry

always @ (*) begin
    if(S == 1) // subtraction
    begin
        temp = {1'b0, A} - {1'b0, B}; // Extend A and B to 5 bits for proper subtraction
        if(C == 1) temp = temp - 1;
        F = temp[3:0];
        C_out = (temp[4] == 1) ? 0 : 1; // Carry-out for subtraction
    end
    else // addition
    begin
        temp = {1'b0, A} + {1'b0, B}; // Extend A and B to 5 bits for proper addition
        if(C == 1) temp = temp + 1;
        F = temp[3:0];
        C_out = (temp[4] == 1) ? 1 : 0; // Carry-out for addition
    end
end

endmodule