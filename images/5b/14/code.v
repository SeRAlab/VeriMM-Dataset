module top_module(
    input signed [31:0] in,
    output reg signed [31:0] out
);// Function to perform the multiplication operation
    function [31:0] multiply_by_two_func;
        input [31:0] in;
        multiply_by_two_func = in * 2;
    endfunction

    // Always block to update output based on input changes
    always @(*) begin
        out = multiply_by_two_func(in);
    end

    // Testbench to verify correct functioning of the module
    initial begin
        // Test case 1: Input is positive
        #10 in = 5;
        #1; // Wait for output to stabilize
        if (out !== 10) begin
            $display("Test case 1 failed: Expected output 10, but got %d", out);
        end

        // Test case 2: Input is negative
        #10 in = -10;
        #1; // Wait for output to stabilize
        if (out !== -20) begin
            $display("Test case 2 failed: Expected output -20, but got %d", out);
        end

        // Test case 3: Input is zero
        #10 in = 0;
        #1; // Wait for output to stabilize
        if (out !== 0) begin
            $display("Test case 3 failed: Expected output 0, but got %d", out);
        end

        // Test case 4: Input is maximum positive value
        #10 in = 2147483647;
        #1; // Wait for output to stabilize
        if (out !== 4294967294) begin
            $display("Test case 4 failed: Expected output 4294967294, but got %d", out);
        end

        // Test case 5: Input is minimum negative value
        #10 in = -2147483648;
        #1; // Wait for output to stabilize
        if (out !== -4294967296) begin
            $display("Test case 5 failed: Expected output -4294967296, but got %d", out);
        end

        // If all test cases pass, display a success message
        $display("All test cases passed");
    end

endmodule