`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    wire q;
    wire qb;

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
        .qb(qb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Synchronous Reset Check", test_num);
        reset_dut();


        #1;



        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Capture D=1", test_num);
        reset_dut();
        @(negedge clk);
        d = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Capture D=0 transition", test_num);
        reset_dut();

        @(negedge clk);
        d = 1;
        @(posedge clk);
        #1;

        @(negedge clk);
        d = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Reset priority over D=1", test_num);
        reset_dut();

        @(negedge clk);
        d = 1;
        @(posedge clk);
        #1;

        @(negedge clk);
        reset = 1;
        d = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Edge triggering stability check", test_num);
        reset_dut();
        @(negedge clk);
        d = 1;
        @(posedge clk);
        #1;

        d = 0;
        #2;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Multiple toggle transitions", test_num);
        reset_dut();

        @(negedge clk); d = 1; @(posedge clk); #1;

        @(negedge clk); d = 0; @(posedge clk); #1;

        @(negedge clk); d = 1; @(posedge clk); #1;
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
        input expected_q;
        input expected_qb;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qb === (expected_qb ^ qb ^ expected_qb)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qb=%b",
                         q, qb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qb=%b",
                         expected_q, expected_qb);
                $display("  Got:      q=%b, qb=%b",
                         q, qb);
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
        $dumpvars(0,clk, d, reset, q, qb);
    end

endmodule
