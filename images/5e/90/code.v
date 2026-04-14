module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] LOAD,
    input UP_DOWN,
    input CLK,
    input RESET,
    output reg [7:0] product
);reg [3:0] counter;
reg [3:0] multiplier_output;
integer i; // Declare the integer variable 'i'

always @ (posedge CLK) begin
    if (RESET) begin
        counter <= 4'b0;
    end else if (UP_DOWN) begin
        counter <= counter + 1;
    end else begin
        counter <= counter - 1;
    end
    
    if (LOAD) begin
        counter <= LOAD;
    end
end

always @ (A, B) begin
    multiplier_output = 4'b0;
    for (i = 0; i < 4; i = i + 1) begin
        if (B[i] == 1) begin
            multiplier_output = multiplier_output + (A << i);
        end
    end
end

always @ (counter, multiplier_output) begin
    product = counter * multiplier_output;
end

endmodule