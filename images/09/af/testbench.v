`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: x = 0 (Check intercept b)");
            x = 32'd0;

            #1;


            check_outputs(32'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: x = 1");
            x = 32'd1;

            #1;


            check_outputs(32'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: x = 10");
            x = 32'd10;

            #1;


            check_outputs(32'd25);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: x = 100");
            x = 32'd100;

            #1;


            check_outputs(32'd205);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: x = 5000");
            x = 32'd5000;

            #1;


            check_outputs(32'd10005);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
