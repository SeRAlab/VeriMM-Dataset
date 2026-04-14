`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] d;
    reg set;
    wire [19:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .set(set),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        set <= 1;
        d <= 20'h00000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        #1;



        check_outputs(20'hFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        set <= 0;
        d <= 20'h00000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'h00000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        set <= 0;
        d <= 20'hA5A5A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'hA5A5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        set <= 1;
        d <= 20'h12345;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'hFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        set <= 0;
        d <= 20'hABCDE;
        @(posedge clk);
        #1;

        d <= 20'h54321;
        #2;

        #1;


        check_outputs(20'hABCDE);
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
        input [19:0] expected_q;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, d, set, q);
    end

endmodule
