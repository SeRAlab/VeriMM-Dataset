module ShiftRows(  
    input wire clk,  
    input wire rst,  
    input wire [127:0] state_in,  
    output reg [127:0] state_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state_out <= 128'b0;  
        end else begin  
            state_out[127:120] <= state_in[127:120]; // Row 0 stays the same  
            state_out[119:112] <= state_in[111:104]; // Row 1 shifts left by 1  
            state_out[111:104] <= state_in[95:88];   // Row 2 shifts left by 2  
            state_out[103:96] <= state_in[79:72];    // Row 3 shifts left by 3  
        end  
    end  
endmodule