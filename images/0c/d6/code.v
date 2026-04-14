module deserializer(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] data_in,  
    input wire valid,  
    output reg [31:0] data_out,  
    output reg data_ready  
);  
    reg [2:0] count;  
    reg [31:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 3'b000;  
            shift_reg <= 32'b0;  
            data_ready <= 1'b0;  
        end else if (valid) begin  
            shift_reg <= {shift_reg[27:0], data_in};  
            count <= count + 1;  
            if (count == 3'b111) begin  
                data_out <= shift_reg;  
                data_ready <= 1'b1;  
                count <= 3'b000;  
                shift_reg <= 32'b0;  
            end else begin  
                data_ready <= 1'b0;  
            end  
        end  
    end  
endmodule