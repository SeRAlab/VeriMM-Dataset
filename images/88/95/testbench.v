`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg atm_valid;
    reg dtm_valid;
    reg itm_valid;
    wire [1:0] compute_tm_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .atm_valid(atm_valid),
        .dtm_valid(dtm_valid),
        .itm_valid(itm_valid),
        .compute_tm_count(compute_tm_count)
    );
    task testcase001;

    begin
        test_num = 1;
        atm_valid = 1'b0; dtm_valid = 1'b0; itm_valid = 1'b0;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        atm_valid = 1'b0; dtm_valid = 1'b0; itm_valid = 1'b1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        atm_valid = 1'b0; dtm_valid = 1'b1; itm_valid = 1'b0;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        atm_valid = 1'b0; dtm_valid = 1'b1; itm_valid = 1'b1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        atm_valid = 1'b1; dtm_valid = 1'b0; itm_valid = 1'b0;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        atm_valid = 1'b1; dtm_valid = 1'b0; itm_valid = 1'b1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        atm_valid = 1'b1; dtm_valid = 1'b1; itm_valid = 1'b0;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        atm_valid = 1'b1; dtm_valid = 1'b1; itm_valid = 1'b1;
        #1;

        check_outputs(2'd3);
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
        input [1:0] expected_compute_tm_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compute_tm_count === (expected_compute_tm_count ^ compute_tm_count ^ expected_compute_tm_count)) begin
                $display("PASS");
                $display("  Outputs: compute_tm_count=%h",
                         compute_tm_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compute_tm_count=%h",
                         expected_compute_tm_count);
                $display("  Got:      compute_tm_count=%h",
                         compute_tm_count);
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
