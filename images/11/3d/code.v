module sample_rate_converter (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] din,  
    output reg [7:0] dout,  
    output reg valid  
);  
    reg [1:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dout <= 8'b0;  
            valid <= 1'b0;  
            count <= 2'b0;  
        end else begin  
            if (count == 2'b01) begin  
                dout <= din;  
                valid <= 1'b1;  
                count <= 2'b00;  
            end else begin  
                valid <= 1'b0;  
                count <= count + 1;  
            end  
        end  
    end  
endmodule