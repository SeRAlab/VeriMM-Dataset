module crc_generator (  
    input [7:0] data_in,  
    output reg [7:0] crc_out  
);  
    wire [15:0] dividend;  
    reg [15:0] divisor = 16'b100000111; // x^8 + x^2 + x + 1  
    reg [15:0] remainder;  
    integer i;  

    assign dividend = {data_in, 8'b00000000}; // Append 8 zero bits to the input data  

    always @(*) begin  
        remainder = dividend;  
        for (i = 15; i >= 8; i = i - 1) begin  
            if (remainder[i]) begin  
                remainder = remainder ^ (divisor << (i - 8));  
            end  
        end  
        crc_out = remainder[7:0]; // Take the lower 8 bits as CRC  
    end  
endmodule