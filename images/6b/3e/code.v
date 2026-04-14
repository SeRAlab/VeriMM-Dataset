module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input load,       // Active-high parallel load input
    input [3:0] load_value, // 4-bit load value
    output [3:0] q,  // 4-bit output from the functional module
    output carry);// Carry output from the counter

    // Counter module
    reg [3:0] counter;
    wire [3:0] next_counter;
    assign carry = (counter == 9) ? 1'b1 : 1'b0;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0;
        end else if (load) begin
            counter <= load_value;
        end else begin
            counter <= next_counter;
        end
    end

    assign next_counter = (counter == 4'b1001) ? 4'b0000 : counter + 1;

    // XOR gate module
    wire xor_output;
    wire and_output1;
    wire and_output2;
    wire not_output;

    assign and_output1 = counter[1] & counter[3];
    assign and_output2 = ~counter[1] & ~counter[3];
    assign not_output = and_output1 | and_output2;
    assign xor_output = ~not_output;

    // Functional module
    reg [3:0] functional_output;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            functional_output <= 4'b0;
        end else if (load) begin
            functional_output <= load_value ^ xor_output;
        end else begin
            functional_output <= next_functional_output;
        end
    end

    wire [3:0] next_functional_output;
    assign next_functional_output = (functional_output + xor_output) & 4'hF;

    assign q = functional_output;

endmodule