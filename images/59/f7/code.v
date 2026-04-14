module top_module( DATA_A, DATA_B, ENABLE, CLK, RESULT, VALID );input [3:0] DATA_A;
input [3:0] DATA_B;
input ENABLE;
input CLK;
output [7:0] RESULT;
output VALID;

reg [7:0] temp_result; // register to store the intermediate result
reg valid; // register to store the valid signal

// Combinational logic to perform multiplication
always @(*) begin
    if (ENABLE) begin
        temp_result = {DATA_A, 4'b0} * {DATA_B, 4'b0};
        valid = 1;
    end
    else begin
        temp_result = 8'b0;
        valid = 0;
    end
end

// Register to synchronize the output with the clock
reg [7:0] result_reg;
always @(posedge CLK) begin
    result_reg <= temp_result;
end

assign RESULT = result_reg;
assign VALID = valid;

endmodule