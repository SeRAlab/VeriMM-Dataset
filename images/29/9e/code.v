module rs_encoder (  
    input clk,  
    input rst,  
    input [31:0] data_in,  
    input data_valid,  
    output reg [31:0] encoded_out,  
    output reg valid_out  
);  
    reg [7:0] data[0:3];  
    reg [7:0] parity[0:1];  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            encoded_out <= 32'b0;  
            valid_out <= 1'b0;  
            for (i = 0; i < 4; i = i + 1)  
                data[i] <= 8'b0;  
            for (i = 0; i < 2; i = i + 1)  
                parity[i] <= 8'b0;  
        end else if (data_valid) begin  
            {data[0], data[1], data[2], data[3]} <= data_in;  
            // Simple parity calculation (for demonstration purposes)  
            parity[0] <= data[0] ^ data[1];  
            parity[1] <= data[2] ^ data[3];  
            encoded_out <= {data[0], data[1], data[2], data[3], parity[0], parity[1]};  
            valid_out <= 1'b1;  
        end  
    end  
endmodule