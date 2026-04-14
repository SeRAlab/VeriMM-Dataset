module top_module( 
    input clk,
    input reset,            // Synchronous reset
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [7:0] final_output
);// 6-to-1 Multiplexer
    wire [3:0] mux_output;
    assign mux_output = (sel == 0) ? data0 :
                        (sel == 1) ? data1 :
                        (sel == 2) ? data2 :
                        (sel == 3) ? data3 :
                        (sel == 4) ? data4 :
                        (sel == 5) ? data5 : 4'b0;
    
    // 8-bit Shift Register
    reg [7:0] shift_reg;
    always @(negedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], mux_output};
        end
    end
    
    // Final Output
    assign final_output = shift_reg + mux_output;
    
endmodule