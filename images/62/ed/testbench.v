`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] idx;
    wire [26:0] base;
    wire [17:0] fd;
    wire [10:0] sd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .idx(idx),
        .base(base),
        .fd(fd),
        .sd(sd)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: idx = 0", test_num);
        idx = 7'd0;


        #1;



        check_outputs(27'h0, 18'h0, 11'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: idx = 1", test_num);
        idx = 7'd1;

        #1;


        check_outputs(27'h0, 18'h0, 11'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: idx = 64", test_num);
        idx = 7'd64;
        #1;

        check_outputs(27'h0, 18'h0, 11'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: idx = 127", test_num);
        idx = 7'd127;
        #1;

        check_outputs(27'h0, 18'h0, 11'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: idx = 42", test_num);
        idx = 7'd42;
        #1;

        check_outputs(27'h0, 18'h0, 11'h0);
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
        input [26:0] expected_base;
        input [17:0] expected_fd;
        input [10:0] expected_sd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_base === (expected_base ^ base ^ expected_base) &&
                expected_fd === (expected_fd ^ fd ^ expected_fd) &&
                expected_sd === (expected_sd ^ sd ^ expected_sd)) begin
                $display("PASS");
                $display("  Outputs: base=%h, fd=%h, sd=%h",
                         base, fd, sd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: base=%h, fd=%h, sd=%h",
                         expected_base, expected_fd, expected_sd);
                $display("  Got:      base=%h, fd=%h, sd=%h",
                         base, fd, sd);
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
