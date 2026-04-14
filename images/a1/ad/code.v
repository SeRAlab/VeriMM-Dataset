module top_module(
    input wire clk,
    input wire rst,
    input wire load_i,
    input wire [31:0] Data_A_i,
    input wire [31:0] Data_B_i,
    output wire [63:0] sgf_result_o
);// Booth's multiplication algorithm
    // Split input data streams into 16-bit chunks
    wire [15:0] A0 = Data_A_i[15:0];
    wire [15:0] A1 = Data_A_i[31:16];
    wire [15:0] B0 = Data_B_i[15:0];
    wire [15:0] B1 = Data_B_i[31:16];
    
    // Compute partial products
    wire [31:0] P0 = A0 * B0;
    wire [31:0] P1 = A1 * B0;
    wire [31:0] P2 = A0 * B1;
    wire [31:0] P3 = A1 * B1;
    
    // Add partial products
    wire [63:0] sum = {P0, 32'b0} + {P1, 16'b0} + {P2, 16'b0} + {P3, 48'b0};
    
    // Output result
    reg [63:0] sgf_result;
    always @ (posedge clk) begin
        if (rst) begin
            sgf_result <= 0;
        end else if (load_i) begin
            sgf_result <= sum;
        end
    end
    
    assign sgf_result_o = sgf_result;

endmodule