module four_bit_selector(input [3:0] a, output reg [1:0] o);
    wire [3:0] a_shifted;
    assign a_shifted = a >> 2; // shift input right by 2 bits
    
    always @(*) begin
        if (a < 5) begin
            o = a[1:0]; // output 2 least significant bits of input
        end else begin
            o = a_shifted[3:2]; // output 2 most significant bits of shifted input
        end
    end
endmodule