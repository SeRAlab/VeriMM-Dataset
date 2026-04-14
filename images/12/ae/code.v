module deserializer_32bit (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] data_in,  
    output reg [31:0] data_out  
);  

    reg [2:0] counter;  
    reg [31:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 3'b000;  
            shift_reg <= 32'b0;  
            data_out <= 32'b0;  
        end else begin  
            shift_reg <= {shift_reg[27:0], data_in};  
            counter <= counter + 1;  
            if (counter == 3'b111) begin  
                data_out <= shift_reg;  
                counter <= 3'b000;  
            end  
        end  
    end  
endmodule