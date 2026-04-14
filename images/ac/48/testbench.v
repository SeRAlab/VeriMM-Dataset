`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg s0;
    reg s1;
    reg x0;
    reg x1;
    reg x2;
    reg x3;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s0(s0),
        .s1(s1),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            s1 = 1'b0; s0 = 1'b0;
            x0 = 1'b0; x1 = 1'b1; x2 = 1'b1; x3 = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            s1 = 1'b0; s0 = 1'b0;
            x0 = 1'b1; x1 = 1'b0; x2 = 1'b0; x3 = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            s1 = 1'b0; s0 = 1'b1;
            x0 = 1'b1; x1 = 1'b0; x2 = 1'b1; x3 = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            s1 = 1'b0; s0 = 1'b1;
            x0 = 1'b0; x1 = 1'b1; x2 = 1'b0; x3 = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            s1 = 1'b1; s0 = 1'b0;
            x0 = 1'b1; x1 = 1'b1; x2 = 1'b0; x3 = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            s1 = 1'b1; s0 = 1'b0;
            x0 = 1'b0; x1 = 1'b0; x2 = 1'b1; x3 = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            s1 = 1'b1; s0 = 1'b1;
            x0 = 1'b1; x1 = 1'b1; x2 = 1'b1; x3 = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            s1 = 1'b1; s0 = 1'b1;
            x0 = 1'b0; x1 = 1'b0; x2 = 1'b0; x3 = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            x0 = 1'b0; x1 = 1'b1; x2 = 1'b0; x3 = 1'b1;

            s1 = 0; s0 = 0; #5;
            s1 = 0; s0 = 1; #5;
            s1 = 1; s0 = 0; #5;
            s1 = 1; s0 = 1; #5;

            #5;
            #1;

            check_outputs(1'b1);
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
        testcase009();
        
        
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
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
