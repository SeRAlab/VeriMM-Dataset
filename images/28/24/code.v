module serializer (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] data_in,  
    output reg serial_out,  
    output reg valid  
);  
    reg [3:0] counter;  
    reg [15:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            serial_out <= 0;  
            valid <= 0;  
            shift_reg <= 0;  
        end else begin  
            if (counter < 16) begin  
                shift_reg <= data_in;  
                serial_out <= shift_reg[15];  
                shift_reg <= shift_reg << 1;  
                counter <= counter + 1;  
                valid <= 1;  
            end else begin  
                valid <= 0;  
            end  
        end  
    end  
endmodule