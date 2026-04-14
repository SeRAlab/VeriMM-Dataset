module bluetooth_signal_comparator(
    input [7:0] signal_strength_a,
    input [7:0] signal_strength_b,
    output reg [1:0] strongest
);
    always @(*) begin
        if (signal_strength_a > signal_strength_b) 
            strongest = 2'b01; // A is stronger
        else if (signal_strength_a < signal_strength_b) 
            strongest = 2'b10; // B is stronger
        else 
            strongest = 2'b00; // Equal strength
    end
endmodule