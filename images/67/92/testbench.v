`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg y;
    reg z;
    wire s_pos;
    wire s_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z),
        .s_pos(s_pos),
        .s_sop(s_sop)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase001: Input 000 (Value 0)");
        x = 1'b0; y = 1'b0; z = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase002: Input 001 (Value 1)");
        x = 1'b0; y = 1'b0; z = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase003: Input 010 (Value 2)");
        x = 1'b0; y = 1'b1; z = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase004: Input 011 (Value 3)");
        x = 1'b0; y = 1'b1; z = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running testcase005: Input 100 (Value 4)");
        x = 1'b1; y = 1'b0; z = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running testcase006: Input 101 (Value 5)");
        x = 1'b1; y = 1'b0; z = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running testcase007: Input 110 (Value 6)");
        x = 1'b1; y = 1'b1; z = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_s_pos;
        input expected_s_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s_pos === (expected_s_pos ^ s_pos ^ expected_s_pos) &&
                expected_s_sop === (expected_s_sop ^ s_sop ^ expected_s_sop)) begin
                $display("PASS");
                $display("  Outputs: s_pos=%b, s_sop=%b",
                         s_pos, s_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_pos=%b, s_sop=%b",
                         expected_s_pos, expected_s_sop);
                $display("  Got:      s_pos=%b, s_sop=%b",
                         s_pos, s_sop);
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
