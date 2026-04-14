module DAC_Controller (
    input [23:0] data_in,
    output reg [2:0] control_out
);
    wire [7:0] segment0 = data_in[23:16];
    wire [7:0] segment1 = data_in[15:8];
    wire [7:0] segment2 = data_in[7:0];

    always @(*) begin
        if (segment0 > segment1 && segment0 > segment2) 
            control_out = 3'b000; // Segment 0 is the highest
        else if (segment1 > segment0 && segment1 > segment2) 
            control_out = 3'b001; // Segment 1 is the highest
        else if (segment2 > segment0 && segment2 > segment1) 
            control_out = 3'b010; // Segment 2 is the highest
        else 
            control_out = 3'b111; // All segments are equal or all zero
    end
endmodule