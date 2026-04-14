module top_module(
    input clk,
    input reset,
    input [7:0] address,
    input [15:0] data_in,
    output [15:0] data_out
);reg [15:0] accumulator;
reg [7:0] program_counter;

reg [15:0] memory [255:0];

always @(posedge clk) begin
    if (reset) begin
        accumulator <= 16'b0;
        program_counter <= 8'b0;
    end else begin
        case (memory[program_counter])
            3'h0: accumulator <= accumulator + memory[address];
            3'h1: accumulator <= accumulator - memory[address];
            3'h2: accumulator <= accumulator & memory[address];
            3'h3: accumulator <= accumulator | memory[address];
            3'h4: accumulator <= accumulator ^ memory[address];
            3'h5: accumulator <= memory[address];
            3'h6: memory[address] <= accumulator;
            default: accumulator <= accumulator;
        endcase
        program_counter <= program_counter + 1;
    end
end

assign data_out = accumulator;

endmodule