module top_module(
    input clk,
    input signed [23:0] in1,
    input signed [23:0] in2,
    output reg signed [47:0] res // Changed to reg type to be assignable in always block
);reg signed [47:0] temp_res;
    reg signed [47:0] final_res;
    reg signed [23:0] temp_in2;

    always @(posedge clk) begin
        // handle negative inputs
        if (in1[23] == 1) begin
            temp_res = -{24'b0, in2} * -{24'b0, in1};
        end else if (in2[23] == 1) begin
            temp_res = -{24'b0, in1} * -{24'b0, in2};
        end else begin
            temp_res = {24'b0, in1} * {24'b0, in2};
        end

        // handle overflow and underflow
        if (temp_res[47] == 0) begin
            final_res = temp_res;
        end else if (in1[23] == in2[23]) begin
            final_res = {temp_res[47], temp_res[46], temp_res[45], temp_res[44], temp_res[43], temp_res[42], temp_res[41], temp_res[40], temp_res[39], temp_res[38], temp_res[37], temp_res[36], temp_res[35], temp_res[34], temp_res[33], temp_res[32], temp_res[31], temp_res[30], temp_res[29], temp_res[28], temp_res[27], temp_res[26], temp_res[25], temp_res[24], 24'b0};
        end else begin
            final_res = {temp_res[47], temp_res[46], temp_res[45], temp_res[44], temp_res[43], temp_res[42], temp_res[41], temp_res[40], temp_res[39], temp_res[38], temp_res[37], temp_res[36], temp_res[35], temp_res[34], temp_res[33], temp_res[32], temp_res[31], temp_res[30], temp_res[29], temp_res[28], temp_res[27], temp_res[26], temp_res[25], temp_res[24], 24'b1};
        end

        // handle negative input 2
        if (in2[23] == 1) begin
            temp_in2 = -in2;
        end else begin
            temp_in2 = in2;
        end

        // handle negative input 1
        if (in1[23] == 1) begin
            res = -{24'b0, temp_in2}; // Ensure res is assigned here, now valid
        end else begin
            res = {24'b0, temp_in2}; // Ensure res is assigned here, now valid
        end
    end

endmodule