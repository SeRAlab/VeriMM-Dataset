module barrel_shifter(  
    input [3:0] data_in,  
    input control,  
    output reg [3:0] data_out  
);  
    always @(*) begin  
        if (control) begin  
            // Right shift  
            data_out = {data_in[0], data_in[3:1]};  
        end else begin  
            // Left shift  
            data_out = {data_in[2:0], data_in[3]};  
        end  
    end  
endmodule