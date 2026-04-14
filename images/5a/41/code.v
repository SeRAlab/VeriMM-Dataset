module top_module(

    input start, clk,
    input [3:0] multiplier_address, multiplicand_address,
    output reg [7:0] p,
    output reg done
    
    );reg [3:0] multiplier, multiplicand;
    reg [7:0] product;
    reg [3:0] counter;
    reg [3:0] adder_input;
    reg [7:0] adder_output;
    reg [3:0] shift_input;
    reg [3:0] shift_output;
    reg [3:0] shift_reg [0:3];
    reg [7:0] shift_reg_output;
    
    integer i;
    
    always @(posedge clk) begin
        if (start) begin
            multiplier <= multiplier_address;
            multiplicand <= multiplicand_address;
            counter <= 4'b0000;
            product <= 8'b00000000;
            done <= 0;
        end else begin
            if (counter == 4'b0000) begin
                adder_input <= 4'b0000;
                shift_input <= multiplicand;
            end else begin
                adder_input <= {shift_output, multiplier[counter-1]};
                shift_input <= shift_reg_output;
            end
            adder_output <= adder_input + shift_input;
            shift_output <= shift_reg[3];
            for (i = 3; i > 0; i = i - 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            shift_reg[0] <= adder_output[3:0];
            shift_reg_output <= {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
            product <= {shift_reg_output, adder_output[7:4]};
            counter <= counter + 1;
            if (counter == 4'b0100) begin
                done <= 1;
            end
        end
    end
    
    assign p = product;
    
endmodule