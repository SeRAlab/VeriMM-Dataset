module top_module(
    input                clk,
    input                reset,
    input                [3:0] adder_in1, // 4-bit input 1 for the adder
    input                [3:0] adder_in2, // 4-bit input 2 for the adder
    input                cin, // Carry-in for the adder
    output               [3:0] out // 4-bit output from the functional module
);// 4-bit adder using combinational logic
    wire [3:0] adder_out;
    wire cout;
    assign {cout, adder_out} = adder_in1 + adder_in2 + cin;

    // 4-bit counter with cyclic state sequence
    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            case (counter)
                4'b0000: counter <= 4'b0001;
                4'b0001: counter <= 4'b0011;
                4'b0011: counter <= 4'b0111;
                4'b0111: counter <= 4'b1111;
                4'b1111: counter <= 4'b0000;
            endcase
        end
    end

    // Functional module that outputs the bitwise XOR of the adder and counter
    assign out = adder_out ^ counter;

endmodule