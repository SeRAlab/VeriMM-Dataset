module turbo_encoder (  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    output reg [5:0] encoded_out  
);  
    wire [3:0] interleaved_data;  
    wire [5:0] enc1_out;  
    wire [5:0] enc2_out;  
    reg [3:0] shift_reg;  
      
    // Interleaver  
    assign interleaved_data = {data_in[1], data_in[0], data_in[3], data_in[2]};  
      
    // First convolutional encoder  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 4'b0;  
        end else begin  
            shift_reg <= {data_in[0], shift_reg[3:1]};  
        end  
    end  
      
    assign enc1_out[0] = shift_reg[0] ^ shift_reg[1];  
    assign enc1_out[1] = shift_reg[1] ^ shift_reg[2];  
    assign enc1_out[2] = shift_reg[2] ^ shift_reg[3];  
    assign enc1_out[3] = shift_reg[2];  
    assign enc1_out[4] = shift_reg[3];  
    assign enc1_out[5] = shift_reg[0];  
      
    // Second convolutional encoder  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            encoded_out <= 6'b0;  
        end else begin  
            encoded_out <= {enc1_out[5:0], interleaved_data[3:0]};  
        end  
    end  
      
endmodule