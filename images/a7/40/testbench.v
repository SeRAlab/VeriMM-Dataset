`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Valid_add;
    wire [8:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Valid_add(Valid_add),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic addition (10 + 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            Valid_add = 1;
            #10;
            #1;

            check_outputs(9'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Change inputs while Valid_add is 0 (Maintain state)", test_num);
            Valid_add = 0;
            A = 8'd50;
            B = 8'd50;
            #10;
            #1;

            check_outputs(9'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Perform addition after hold (50 + 50)", test_num);
            Valid_add = 1;
            A = 8'd50;
            B = 8'd50;
            #10;
            #1;

            check_outputs(9'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Boundary condition - 8-bit carry (255 + 1)", test_num);
            Valid_add = 1;
            A = 8'd255;
            B = 8'd1;
            #10;
            #1;

            check_outputs(9'd256);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Maximum values (255 + 255)", test_num);
            Valid_add = 1;
            A = 8'd255;
            B = 8'd255;
            #10;
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            Valid_add = 1;
            A = 8'd0;
            B = 8'd0;
            #10;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Verify latching 0 while inputs change", test_num);
            Valid_add = 0;
            A = 8'hFF;
            B = 8'hAA;
            #10;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Late validation (128 + 128)", test_num);
            A = 8'd128;
            B = 8'd128;
            Valid_add = 0;
            #5;
            Valid_add = 1;
            #10;
            #1;

            check_outputs(9'd256);
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
        input [8:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
