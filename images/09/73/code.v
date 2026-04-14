module RS_Encoder(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] data_in,  
    output reg [5:0] encoded_out  
);  
    reg [3:0] data_reg;  
    reg [1:0] parity;  
    reg [2:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 0;  
            encoded_out <= 0;  
            data_reg <= 0;  
            parity <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    data_reg <= data_in;  
                    state <= 1;  
                end  
                1: begin  
                    // Simple example of parity calculation (not actual GF encoding)  
                    parity[0] <= ^data_reg;  
                    parity[1] <= ~^data_reg;  
                    encoded_out <= {data_reg, parity};  
                    state <= 2;  
                end  
                2: begin  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule