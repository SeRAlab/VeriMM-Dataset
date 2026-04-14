module crc_generator (  
    input [7:0] data,  
    output [7:0] crc  
);  
    wire [7:0] polynomial = 8'b100000111;  
    reg [7:0] crc_reg;  

    integer i;  
    always @(*) begin  
        crc_reg = data;  
        for (i = 0; i < 8; i = i + 1) begin  
            if (crc_reg[7] == 1'b1) begin  
                crc_reg = crc_reg ^ polynomial;  
            end  
            crc_reg = {crc_reg[6:0], 1'b0};  
        end  
    end  

    assign crc = crc_reg;  
endmodule