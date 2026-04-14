`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg free2;
    reg free3;
    reg [1:0] tm_count;
    wire [3:0] fifowp_inc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .free2(free2),
        .free3(free3),
        .tm_count(tm_count),
        .fifowp_inc(fifowp_inc)
    );
    task testcase001;

    begin
        test_num = 1;
        free3 = 1; free2 = 1; tm_count = 2'd3;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        free3 = 0; free2 = 1; tm_count = 2'd3;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        free3 = 1; free2 = 1; tm_count = 2'd2;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        free3 = 0; free2 = 0; tm_count = 2'd3;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        free3 = 1; free2 = 0; tm_count = 2'd2;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        free3 = 1; free2 = 1; tm_count = 2'd1;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        free3 = 1; free2 = 1; tm_count = 2'd0;
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_fifowp_inc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fifowp_inc === (expected_fifowp_inc ^ fifowp_inc ^ expected_fifowp_inc)) begin
                $display("PASS");
                $display("  Outputs: fifowp_inc=%h",
                         fifowp_inc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifowp_inc=%h",
                         expected_fifowp_inc);
                $display("  Got:      fifowp_inc=%h",
                         fifowp_inc);
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
