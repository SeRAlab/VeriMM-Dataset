module turbo_encoder (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [5:0] encoded_out
);
    reg [1:0] memory;
    reg [3:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 2'b00;
            data_reg <= 4'b0000;
            encoded_out <= 6'b000000;
        end else begin
            data_reg <= data_in;
            memory <= {memory[0], data_reg[0]}; // Shift in new bit
            encoded_out <= {memory[1] ^ data_reg[2], 
                            memory[0] ^ data_reg[1], 
                            data_reg[0], 
                            memory[1] ^ data_reg[3], 
                            memory[0] ^ data_reg[2], 
                            data_reg[1]};
        end
    end
endmodule