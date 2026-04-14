module top_module(
    input clk,
    input reset,
    input [3:0] DIN,
    input [15:0] A,
    input [15:0] B,
    input [3:0] S,
    output reg [15:0] Y,
    output reg [7:0] DAC_out,
    output reg [15:0] final_output
);reg [3:0] DAC_input;
reg [7:0] DAC_out_reg;
reg [15:0] shifted_output;
integer i;  // Declare i as an integer

// DAC module
always @ (posedge clk) begin
    if (reset) begin
        DAC_input <= 0;
        DAC_out_reg <= 0;
    end else begin
        DAC_input <= DIN;
        DAC_out_reg <= DAC_input * 64;
    end
end

assign DAC_out = DAC_out_reg;

// Barrel shifter module
always @ (A, B, S) begin
    shifted_output = 0;  // Initialize shifted_output to 0
    case (S)
        4'b0000: shifted_output <= A;
        4'b1111: shifted_output <= B;
        default: begin
            for (i = 0; i < 16; i = i + 1) begin
                if (S[3] == 1) shifted_output[i] <= B[i];
                else shifted_output[i] <= A[i];
                if (S[2] == 1) shifted_output[i] <= shifted_output[i] << 1;
                if (S[1] == 1) shifted_output[i] <= shifted_output[i] << 1;
                if (S[0] == 1) shifted_output[i] <= shifted_output[i] << 1;
            end
        end
    endcase
end

// Final output module
always @ (DAC_out, shifted_output) begin
    final_output <= DAC_out + shifted_output;
end

endmodule