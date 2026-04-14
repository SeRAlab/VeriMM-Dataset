module crc_generator (  
    input [7:0] data,  
    output reg [7:0] crc  
);  
    integer i;  
    reg [7:0] tmp;  

    always @(*) begin  
        tmp = data;  
        crc = 8'b0;  
        for (i = 0; i < 8; i = i + 1) begin  
            if (tmp[7] == 1'b1) begin  
                tmp = tmp ^ 8'h07;  
            end  
            tmp = tmp << 1;  
        end  
        crc = tmp;  
    end  
endmodule