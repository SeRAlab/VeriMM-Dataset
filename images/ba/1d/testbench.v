`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg u;
    reg v;
    reg w;
    wire x_pos;
    wire x_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .u(u),
        .v(v),
        .w(w),
        .x_pos(x_pos),
        .x_sop(x_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: u=0, v=0, w=0 (Value 0)");
            u = 0; v = 0; w = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: u=0, v=0, w=1 (Value 1)");
            u = 0; v = 0; w = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: u=0, v=1, w=0 (Value 2)");
            u = 0; v = 1; w = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: u=0, v=1, w=1 (Value 3)");
            u = 0; v = 1; w = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: u=1, v=0, w=0 (Value 4)");
            u = 1; v = 0; w = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: u=1, v=0, w=1 (Value 5)");
            u = 1; v = 0; w = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: u=1, v=1, w=0 (Value 6)");
            u = 1; v = 1; w = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: u=1, v=1, w=1 (Value 7)");
            u = 1; v = 1; w = 1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_x_pos;
        input expected_x_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_pos === (expected_x_pos ^ x_pos ^ expected_x_pos) &&
                expected_x_sop === (expected_x_sop ^ x_sop ^ expected_x_sop)) begin
                $display("PASS");
                $display("  Outputs: x_pos=%b, x_sop=%b",
                         x_pos, x_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_pos=%b, x_sop=%b",
                         expected_x_pos, expected_x_sop);
                $display("  Got:      x_pos=%b, x_sop=%b",
                         x_pos, x_sop);
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
