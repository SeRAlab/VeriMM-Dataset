module phase_shifter(  
    input [4:0] data_in,  
    input [2:0] shift_amount,  
    output reg [4:0] data_out  
);  
    always @(*) begin  
        data_out = (data_in << shift_amount) | (data_in >> (5 - shift_amount));  
    end  
endmodule