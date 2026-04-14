module deserializer_16bit (  
    input wire clk,  
    input wire rst,  
    input wire [1:0] data_in,  
    output reg [15:0] data_out,  
    output reg valid  
);  
    reg [3:0] count;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            data_out <= 0;  
            valid <= 0;  
        end else begin  
            if (count < 8) begin  
                data_out <= {data_out[14:0], data_in};  
                count <= count + 1;  
            end  
            if (count == 7) begin  
                valid <= 1;  
            end else if (count == 8) begin  
                valid <= 0;  
                count <= 0;  
                data_out <= 0;  
            end  
        end  
    end  
endmodule