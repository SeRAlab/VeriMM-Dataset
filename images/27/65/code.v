module deserializer (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] data_in,  
    output reg [15:0] data_out,  
    output reg ready  
);  
    reg [3:0] count;  
    reg [15:0] temp_data;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            temp_data <= 0;  
            data_out <= 0;  
            ready <= 0;  
        end else begin  
            if (count < 4) begin  
                temp_data <= {temp_data[11:0], data_in};  
                count <= count + 1;  
                ready <= 0;  
            end else if (count == 4) begin  
                data_out <= {temp_data[11:0], data_in};  
                ready <= 1;  
                count <= 0;  
                temp_data <= 0;  
            end  
        end  
    end  
endmodule