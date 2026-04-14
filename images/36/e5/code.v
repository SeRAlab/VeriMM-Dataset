module noise_suppression(  
    input [4:0] data_in,  
    output reg [4:0] data_out  
);  
    integer i;  
    always @* begin  
        for (i = 0; i < 5; i = i + 1) begin  
            if (data_in[i] == 1)  
                data_out[i] = (data_in[4:0] == 5'b11111) ? 1 : (data_in[4:0] == 5'b00000) ? 0 : (data_in[i] > 2) ? 1 : 0;  
            else  
                data_out[i] = 0;  
        end  
    end  
endmodule