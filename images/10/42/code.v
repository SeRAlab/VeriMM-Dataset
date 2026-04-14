module crc_generator (  
    input [7:0] data_in,  
    output reg [7:0] crc_out  
);  
    reg [7:0] polynomial = 8'b11000011;  
    reg [15:0] shift_reg;  
    integer i;  

    always @(*) begin  
        shift_reg = {8'b0, data_in};  
        for (i = 0; i < 8; i = i + 1) begin  
            if (shift_reg[15]) begin  
                shift_reg = shift_reg ^ {polynomial, 8'b0};  
            end  
            shift_reg = shift_reg << 1;  
        end  
        crc_out = shift_reg[7:0];  
    end  
endmodule