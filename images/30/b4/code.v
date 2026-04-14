module turbo_encoder (
    input wire clk,
    input wire rst,
    input wire [0:0] data_in,
    input wire data_valid,
    output reg [1:0] encoded_out,
    output reg valid_out
);
    // Internal registers for convolutional encoders
    reg [2:0] shift_reg1, shift_reg2;
    reg [1:0] parity1, parity2;
    reg valid1, valid2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg1 <= 3'b000;
            shift_reg2 <= 3'b000;
            valid_out <= 0;
        end else if (data_valid) begin
            // Shift in new data
            shift_reg1 <= {data_in, shift_reg1[2:1]};
            shift_reg2 <= {data_in, shift_reg2[2:1]};

            // Calculate parity for the first encoder
            parity1 <= {shift_reg1[0] ^ shift_reg1[1], shift_reg1[0]};

            // Calculate parity for the second encoder
            parity2 <= {shift_reg2[0] ^ shift_reg2[1], shift_reg2[0]};

            // Output the encoded data
            encoded_out <= {parity1, parity2};
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end
endmodule