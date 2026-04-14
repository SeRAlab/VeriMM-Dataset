module ofdm_mapper (  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    output reg [3:0] subcarrier_out  
);  

    reg [2:0] state;  // State variable for the sequential logic  
    reg [3:0] mapping [0:15];  // Mapping table for 16 symbols  

    initial begin  
        mapping[0] = 4'b0000;  
        mapping[1] = 4'b0001;  
        mapping[2] = 4'b0010;  
        mapping[3] = 4'b0011;  
        mapping[4] = 4'b0100;  
        mapping[5] = 4'b0101;  
        mapping[6] = 4'b0110;  
        mapping[7] = 4'b0111;  
        mapping[8] = 4'b1000;  
        mapping[9] = 4'b1001;  
        mapping[10] = 4'b1010;  
        mapping[11] = 4'b1011;  
        mapping[12] = 4'b1100;  
        mapping[13] = 4'b1101;  
        mapping[14] = 4'b1110;  
        mapping[15] = 4'b1111;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 3'b000;  
            subcarrier_out <= 4'b0000;  
        end else begin  
            state <= data_in[3:0];  // Update state with new input  
            subcarrier_out <= mapping[state];  // Map the input to output  
        end  
    end  
endmodule