`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [22:0] cw_from_cu;
    reg mux_op;
    wire [22:0] cw_from_mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cw_from_cu(cw_from_cu),
        .mux_op(mux_op),
        .cw_from_mux(cw_from_mux)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        cw_from_cu = 23'h000000;
        mux_op = 1'b0;
        $display("Running Testcase001: Pass Mode (Op=0), Input=Zero");
        #1;

        check_outputs(23'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        cw_from_cu = 23'h7FFFFF;
        mux_op = 1'b0;
        $display("Running Testcase002: Pass Mode (Op=0), Input=Max");
        #1;

        check_outputs(23'h7FFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        cw_from_cu = 23'h555555;
        mux_op = 1'b0;
        $display("Running Testcase003: Pass Mode (Op=0), Input=Pattern 5");
        #1;

        check_outputs(23'h555555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        cw_from_cu = 23'h000000;
        mux_op = 1'b1;
        $display("Running Testcase004: Force Mode (Op=1), Input=Zero");
        #1;

        check_outputs(23'h000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        cw_from_cu = 23'h7FFFFF;
        mux_op = 1'b1;
        $display("Running Testcase005: Force Mode (Op=1), Input=Max");
        #1;

        check_outputs(23'h000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        cw_from_cu = 23'h2A2A2A;
        mux_op = 1'b1;
        $display("Running Testcase006: Force Mode (Op=1), Input=Pattern 2A");
        #1;

        check_outputs(23'h000000);
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
        input [22:0] expected_cw_from_mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cw_from_mux === (expected_cw_from_mux ^ cw_from_mux ^ expected_cw_from_mux)) begin
                $display("PASS");
                $display("  Outputs: cw_from_mux=%h",
                         cw_from_mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cw_from_mux=%h",
                         expected_cw_from_mux);
                $display("  Got:      cw_from_mux=%h",
                         cw_from_mux);
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
