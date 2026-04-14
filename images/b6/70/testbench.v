`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] e;
    reg [47:0] k;
    wire [5:0] b1x;
    wire [5:0] b2x;
    wire [5:0] b3x;
    wire [5:0] b4x;
    wire [5:0] b5x;
    wire [5:0] b6x;
    wire [5:0] b7x;
    wire [5:0] b8x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .k(k),
        .b1x(b1x),
        .b2x(b2x),
        .b3x(b3x),
        .b4x(b4x),
        .b5x(b5x),
        .b6x(b6x),
        .b7x(b7x),
        .b8x(b8x)
    );
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            e = 48'h000000000000;
            k = 48'h000000000000;
            #1;

            check_outputs(6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Ones (e) XOR Zeros (k)");
            e = 48'hFFFFFFFFFFFF;
            k = 48'h000000000000;
            #1;

            check_outputs(6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Complementary Bit Patterns");
            e = 48'hAAAAAAAAAAAAAAAA;
            k = 48'h555555555555;

            #1;


            check_outputs(6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Incremental Hex Sequence");
            e = 48'h123456789ABC;
            k = 48'h000000000000;








            #1;









            check_outputs(6'h04, 6'h23, 6'h11, 6'h16, 6'h1E, 6'h09, 6'h2A, 6'h3C);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Arbitrary Bit Patterns");
            e = 48'hAAAABBBBCCCC;
            k = 48'h111111111111;







            #1;








            check_outputs(6'h2E, 6'h3B, 6'h2E, 6'h2A, 6'h2A, 6'h2D, 6'h37, 6'h1D);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Boundary Walking Bit (MSB)");
            e = 48'h800000000000;
            k = 48'h000000000000;


            #1;



            check_outputs(6'h20, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Boundary Walking Bit (LSB)");
            e = 48'h000000000001;
            k = 48'h000000000000;


            #1;



            check_outputs(6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h01);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Identity XOR");
            e = 48'hF0F0F0F0F0F0;
            k = 48'hF0F0F0F0F0F0;

            #1;


            check_outputs(6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [5:0] expected_b1x;
        input [5:0] expected_b2x;
        input [5:0] expected_b3x;
        input [5:0] expected_b4x;
        input [5:0] expected_b5x;
        input [5:0] expected_b6x;
        input [5:0] expected_b7x;
        input [5:0] expected_b8x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b1x === (expected_b1x ^ b1x ^ expected_b1x) &&
                expected_b2x === (expected_b2x ^ b2x ^ expected_b2x) &&
                expected_b3x === (expected_b3x ^ b3x ^ expected_b3x) &&
                expected_b4x === (expected_b4x ^ b4x ^ expected_b4x) &&
                expected_b5x === (expected_b5x ^ b5x ^ expected_b5x) &&
                expected_b6x === (expected_b6x ^ b6x ^ expected_b6x) &&
                expected_b7x === (expected_b7x ^ b7x ^ expected_b7x) &&
                expected_b8x === (expected_b8x ^ b8x ^ expected_b8x)) begin
                $display("PASS");
                $display("  Outputs: b1x=%h, b2x=%h, b3x=%h, b4x=%h, b5x=%h, b6x=%h, b7x=%h, b8x=%h",
                         b1x, b2x, b3x, b4x, b5x, b6x, b7x, b8x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b1x=%h, b2x=%h, b3x=%h, b4x=%h, b5x=%h, b6x=%h, b7x=%h, b8x=%h",
                         expected_b1x, expected_b2x, expected_b3x, expected_b4x, expected_b5x, expected_b6x, expected_b7x, expected_b8x);
                $display("  Got:      b1x=%h, b2x=%h, b3x=%h, b4x=%h, b5x=%h, b6x=%h, b7x=%h, b8x=%h",
                         b1x, b2x, b3x, b4x, b5x, b6x, b7x, b8x);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
