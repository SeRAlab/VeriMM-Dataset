module top_module(
    input clk,    // Clocks are used in sequential circuits
    input d,      // Data input
    input [2:0] sel, // Select input to choose between 6 data inputs
    input [3:0] data0, // Six 4-bit data inputs
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] q // 4-bit output from the selected data input stored in a T flip-flop
);// Combinational logic to select the appropriate 4-bit data input
wire [3:0] selected_data;
assign selected_data = (sel == 3'b000) ? data0 :
                       (sel == 3'b001) ? data1 :
                       (sel == 3'b010) ? data2 :
                       (sel == 3'b011) ? data3 :
                       (sel == 3'b100) ? data4 :
                       (sel == 3'b101) ? data5 :
                       4'b1111; // Output 1 if sel is outside the range of 0 to 5

// Combinational circuit to generate the appropriate T input for the flip-flop
wire t = (d == 1) ? ~q : q;

// T flip-flop to store the selected 4-bit data input
always @(posedge clk) begin
    if (t == 1) q <= selected_data; // Store selected data instead of flipping q
end

endmodule