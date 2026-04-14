module shift_register(  
    input wire clk,  
    input wire load,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    always @(posedge clk) begin  
        if (load)  
            data_out <= data_in;  
        else  
            data_out <= {data_out[2:0], 1'b0};  
    end  
endmodule