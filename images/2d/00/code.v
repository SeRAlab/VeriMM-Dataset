module turbo_encoder (
    input wire [4:0] data_in,
    input wire clk,
    input wire rst,
    output reg [9:0] encoded_out
);
    
    // Convolutional encoder parameters
    parameter K = 3; // constraint length
    parameter G1 = 5'b111; // generator for first encoder
    parameter G2 = 5'b101; // generator for second encoder
    
    reg [4:0] interleaved_data;
    reg [9:0] enc1_out, enc2_out;
    reg [4:0] shift_reg1, shift_reg2;
    integer i;

    // First convolutional encoder
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg1 <= 0;
            enc1_out <= 0;
        end else begin
            shift_reg1 <= {data_in[0], shift_reg1[4:1]};
            enc1_out[0] <= ^(shift_reg1 & G1);
            enc1_out[1] <= ^(shift_reg1 & G1) ^ data_in[0]; // feedback
        end
    end

    // Interleaver
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            interleaved_data <= 0;
        end else begin
            for (i = 0; i < 5; i = i + 1) begin
                interleaved_data[i] <= data_in[(i + 1) % 5];
            end
        end
    end

    // Second convolutional encoder
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg2 <= 0;
            enc2_out <= 0;
        end else begin
            shift_reg2 <= {interleaved_data[0], shift_reg2[4:1]};
            enc2_out[0] <= ^(shift_reg2 & G2);
            enc2_out[1] <= ^(shift_reg2 & G2) ^ interleaved_data[0]; // feedback
        end
    end

    // Combine outputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_out <= 0;
        end else begin
            encoded_out <= {enc1_out, enc2_out};
        end
    end
endmodule