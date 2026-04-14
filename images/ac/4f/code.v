module top_module(
    input        [3:0] A,
    input        [3:0] B,
    input              VPWR,
    input              VGND,
    input              VPB,
    input              VNB,
    output reg [3:0]   X
);wire [4:0] adder_result; // Result of addition
    assign adder_result = {1'b0, A} + {1'b0, B};

    always @(*) begin
        X = adder_result[3:0] - 4'b0101; // Output the lower 4 bits minus 5
    end

endmodule