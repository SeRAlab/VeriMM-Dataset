`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );
    task clock_pulse;

        begin
            #5 clk = 1;
            #5 clk = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial Asynchronous Reset", test_num);
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        #5;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Count to 5", test_num);

        reset = 1; #10; reset = 0; #5;
        clk = 0;

        for (i = 0; i < 5; i = i + 1) begin
            clock_pulse();
        end
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Count to Maximum (15)", test_num);

        reset = 1; #10; reset = 0; #5;
        clk = 0;

        for (i = 0; i < 15; i = i + 1) begin
            clock_pulse();
        end
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Rollover from 15 to 0", test_num);

        reset = 1; #10; reset = 0; #5;
        clk = 0;

        for (i = 0; i < 16; i = i + 1) begin
            clock_pulse();
        end
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Reset during counting", test_num);

        reset = 1; #10; reset = 0; #5;
        clk = 0;

        for (i = 0; i < 7; i = i + 1) begin
            clock_pulse();
        end

        #3 reset = 1;
        #5;
        #1;

        check_outputs(4'd0);
        reset = 0;
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rollover and continue to 3", test_num);

        reset = 1; #10; reset = 0; #5;
        clk = 0;

        for (i = 0; i < 19; i = i + 1) begin
            clock_pulse();
        end
        #1;

        check_outputs(4'd3);
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
        input [3:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
