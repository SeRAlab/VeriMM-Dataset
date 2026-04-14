module sample_rate_converter(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] buffer [0:3];  
    reg [1:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 0;  
            count <= 0;  
        end else begin  
            buffer[count] <= data_in;  
            count <= (count + 1) % 4;  
            if (count == 3) begin  
                data_out <= buffer[3];  
            end  
        end  
    end  
endmodule