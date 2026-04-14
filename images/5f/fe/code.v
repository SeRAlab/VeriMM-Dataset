module top_module(
    input clk,                     // Clock input
    input rst,                     // Reset input
    input [7:0] in_data,          // Input data
    input in_valid,               // Input valid signal
    output reg in_ready,          // Input ready signal
    output reg [7:0] out_data,    // Output data
    output reg out_valid,         // Output valid signal
    input out_ready,              // Output ready signal
    output reg error              // Error signal
);localparam WIDTH = 8;
localparam DEPTH = 16;

reg [WIDTH-1:0] memory [0:DEPTH-1];
reg [3:0] head = 0;
reg [3:0] tail = 0;
reg [1:0] count = 0;
reg error_flag = 0;

// Input logic
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        in_ready <= 1'b0;
    end else if (in_valid && count < DEPTH) begin
        memory[head] <= in_data;
        head <= head + 1;
        count <= count + 1;
        in_ready <= 1'b1;
    end else begin
        in_ready <= 1'b0;
    end
end

// Output logic
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out_data <= 8'h00;
        out_valid <= 1'b0;
        error <= 1'b0;
    end else if (out_ready && count > 0) begin
        out_data <= memory[tail];
        tail <= tail + 1;
        count <= count - 1;
        out_valid <= 1'b1;
        if (error_flag) begin
            error <= 1'b0;
            error_flag <= 1'b0;
        end
    end else if (count == 0) begin
        out_data <= 8'h00;
        out_valid <= 1'b0;
        error <= 1'b1;
        error_flag <= 1'b1;
    end else begin
        out_valid <= 1'b0;
        error <= 1'b0;
    end
end

endmodule