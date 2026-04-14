module RLE_Encoder(  
    input [7:0] data_in,  
    output reg [15:0] encoded_out,  
    output reg [3:0] length_out  
);  
    integer i;  
    reg [3:0] count;  
    reg current_value;  
    always @(*) begin  
        count = 0;  
        encoded_out = 0;  
        length_out = 0;  
        current_value = data_in[0];  
        for (i = 0; i < 8; i = i + 1) begin  
            if (data_in[i] == current_value) begin  
                count = count + 1;  
            end else begin  
                encoded_out = {encoded_out, count, current_value};  
                length_out = length_out + 1;  
                count = 1;  
                current_value = data_in[i];  
            end  
        end  
        encoded_out = {encoded_out, count, current_value};  
        length_out = length_out + 1;  
    end  
endmodule