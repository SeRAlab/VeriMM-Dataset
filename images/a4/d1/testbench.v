`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    wire q;
    wire q_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .q(q),
        .q_n(q_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        d = 0;
        #15;
        reset = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Capture 0 on Rising Edge", test_num);
        reset_dut();
        d = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Capture 1 on Rising Edge", test_num);
        reset_dut();
        d = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Asynchronous Reset Priority", test_num);
        reset_dut();

        d = 1;
        @(posedge clk);
        #2;

        #3;
        reset = 0;
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Data Hold Between Edges", test_num);
        reset_dut();
        d = 1;
        @(posedge clk);
        #2;

        d = 0;
        #5;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Multiple clock transitions", test_num);
        reset_dut();

        d = 1;
        @(posedge clk);
        #2;

        d = 0;
        @(posedge clk);
        #2;

        d = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 1'b0);
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
        input expected_q;
        input expected_q_n;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_n === (expected_q_n ^ q_n ^ expected_q_n)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_n=%b",
                         q, q_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_n=%b",
                         expected_q, expected_q_n);
                $display("  Got:      q=%b, q_n=%b",
                         q, q_n);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, d, reset, q, q_n);
    end

endmodule
