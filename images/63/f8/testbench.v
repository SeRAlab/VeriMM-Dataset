`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    reg set;
    wire q;
    wire qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .set(set),
        .q(q),
        .qn(qn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        set = 1;
        d = 0;
        #10;
        reset = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Asynchronous Reset Check", test_num);
        reset_dut();

        reset = 0;
        #5;
        #1;

        check_outputs(1'b0, 1'b1);
        reset = 1;
        #5;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Asynchronous Set Check", test_num);
        reset_dut();
        set = 0;
        #5;
        #1;

        check_outputs(1'b1, 1'b0);
        set = 1;
        #5;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Synchronous Load '1'", test_num);
        reset_dut();
        d = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Synchronous Load '0'", test_num);
        reset_dut();

        d = 1;
        @(posedge clk);
        #2;

        d = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Edge Sensitivity Check (Falling Edge)", test_num);
        reset_dut();
        d = 1;
        @(negedge clk);
        #2;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Asynchronous Set Override during Clock Cycle", test_num);
        reset_dut();
        d = 0;
        @(posedge clk);
        #2;

        set = 0;
        #3;
        #1;

        check_outputs(1'b1, 1'b0);
        set = 1;
        #2;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Asynchronous Reset while D is high", test_num);
        reset_dut();
        d = 1;
        #2;
        reset = 0;
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
        reset = 1;
        #5;
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
        input expected_q;
        input expected_qn;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qn === (expected_qn ^ qn ^ expected_qn)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qn=%b",
                         q, qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qn=%b",
                         expected_q, expected_qn);
                $display("  Got:      q=%b, qn=%b",
                         q, qn);
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
        $dumpvars(0,clk, d, reset, set, q, qn);
    end

endmodule
