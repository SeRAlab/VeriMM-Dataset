module shift_register (  
    input clk,  
    input reset,  
    input load,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 8'b0;  
        else if (load)  
            data_out <= data_in;  
        else  
            data_out <= {data_out[6:0], 1'b0};  
    end  
endmodule