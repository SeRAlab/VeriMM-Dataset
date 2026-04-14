module top_module(
    input           rst,        // reset input
    input           clk,        // clock input
    input   [1:0]   op,         // operation input (00=addition, 01=subtraction, 10=multiplication, 11=division)
    input   [7:0]   a,          // first operand input
    input   [7:0]   b,          // second operand input
    input           start,      // start signal input
    output          done,       // done signal output
    output  [7:0]   result      // result output
);reg [7:0]   temp_result;    // temporary result
    reg         calculation_done;
    
    always @(posedge clk) begin
        if (rst) begin          // reset
            temp_result <= 8'h00;
            calculation_done <= 1'b0;
        end else if (start) begin   // start calculation
            case(op)
                2'b00: temp_result <= a + b;    // addition
                2'b01: temp_result <= a - b;    // subtraction
                2'b10: temp_result <= a * b;    // multiplication
                2'b11: temp_result <= a / b;    // division
            endcase
            calculation_done <= 1'b1;
        end else begin          // wait for start signal
            calculation_done <= 1'b0;
        end
    end
    
    assign done = calculation_done;
    assign result = temp_result;
    
endmodule