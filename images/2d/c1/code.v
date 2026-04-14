module ofdm_demodulator (  
    input wire clk,  
    input wire rst,  
    input wire serial_in,  
    output reg [3:0] parallel_out,  
    output reg valid  
);  
    reg [3:0] shift_reg;  
    reg [2:0] count;  
    parameter NUM_SUBCARRIERS = 4;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 4'b0;  
            count <= 3'b0;  
            valid <= 0;  
        end else begin  
            shift_reg <= {shift_reg[2:0], serial_in};  
            if (count < NUM_SUBCARRIERS - 1) begin  
                count <= count + 1;  
                valid <= 0;  
            end else begin  
                parallel_out <= shift_reg;  
                valid <= 1;  
                count <= 3'b0;  
            end  
        end  
    end  
endmodule