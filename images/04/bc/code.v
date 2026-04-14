module turbo_encoder (
    input [4:0] data_in,
    input clk,
    input rst,
    output reg [9:0] encoded_out
);
    reg [4:0] shift_reg1, shift_reg2;
    wire [1:0] enc1_out, enc2_out;

    // Convolutional Encoder 1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg1 <= 5'b0;
        end else begin
            shift_reg1 <= {shift_reg1[3:0], data_in[0]};
        end
    end

    assign enc1_out = shift_reg1[4] ^ shift_reg1[2]; // Example polynomial

    // Convolutional Encoder 2
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg2 <= 5'b0;
        end else begin
            shift_reg2 <= {shift_reg2[3:0], data_in[0]};
        end
    end

    assign enc2_out = shift_reg2[4] ^ shift_reg2[1]; // Different polynomial

    // Combine outputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_out <= 10'b0;
        end else begin
            encoded_out <= {enc1_out, enc2_out, data_in};
        end
    end
endmodule