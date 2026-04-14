module deserializer_32bit (  
    input clk,  
    input reset,  
    input [63:0] data_in,  
    output reg [31:0] data_out1,  
    output reg [31:0] data_out2,  
    output reg valid  
);  

    reg [1:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 2'b00;  
            data_out1 <= 32'b0;  
            data_out2 <= 32'b0;  
            valid <= 0;  
        end else begin  
            if (count == 2'b00) begin  
                data_out1 <= data_in[31:0];  
                count <= count + 1;  
            end else if (count == 2'b01) begin  
                data_out2 <= data_in[63:32];  
                valid <= 1;  
                count <= count + 1;  
            end else if (count == 2'b10) begin  
                valid <= 0;  
                count <= 2'b00;  
            end  
        end  
    end  
endmodule