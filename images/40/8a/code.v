module deserializer (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    output reg [15:0] data_out,  
    output reg valid  
);  
    reg [7:0] data_buffer;  
    reg [1:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_buffer <= 8'b0;  
            data_out <= 16'b0;  
            valid <= 1'b0;  
            count <= 2'b0;  
        end else begin  
            if (count < 2) begin  
                data_buffer <= data_in;  
                count <= count + 1;  
            end  
            if (count == 1) begin  
                data_out <= {data_buffer, data_in};  
                valid <= 1'b1;  
            end  
            if (count == 2) begin  
                valid <= 1'b0;  
                count <= 2'b0;  
            end  
        end  
    end  
endmodule