module deserializer_16bit(  
    input wire clk,  
    input wire valid,  
    input wire [7:0] data_in,  
    output reg [15:0] data_out  
);  
    integer count;  
    always @(posedge clk) begin  
        if (valid) begin  
            data_out[count*2 +: 2] <= data_in;  
            count <= count + 1;  
            if (count == 7) begin  
                count <= 0;  
            end  
        end  
    end  
endmodule