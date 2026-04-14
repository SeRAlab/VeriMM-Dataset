module top_module(
    input           rst,        // reset signal
    input           clk,        // clock signal
    input   [7:0]   a,          // input value for register A
    input   [7:0]   b,          // input value for register B
    input   [1:0]   op,         // operation to be performed (00=addition, 01=subtraction, 10=multiplication, 11=division)
    output  [7:0]   c           // output value for register C
);reg [7:0] reg_A;            // register A
    reg [7:0] reg_B;            // register B
    reg [7:0] reg_C;            // register C
    reg [1:0] operation;        // operation to be performed

    always @(posedge clk) begin
        if (rst) begin          // reset the calculator
            reg_A <= 8'h00;
            reg_B <= 8'h00;
            reg_C <= 8'h00;
            operation <= 2'b00;
        end else begin
            reg_A <= a;         // load input value for register A
            reg_B <= b;         // load input value for register B
            operation <= op;    // load operation to be performed

            case(operation)
                2'b00: reg_C <= reg_A + reg_B;   // addition
                2'b01: reg_C <= reg_A - reg_B;   // subtraction
                2'b10: reg_C <= reg_A * reg_B;   // multiplication
                2'b11: reg_C <= reg_A / reg_B;   // division
                default: reg_C <= 8'h00;         // default case (reset)
            endcase
        end
    end

    assign c = reg_C;           // assign output value for register C

endmodule