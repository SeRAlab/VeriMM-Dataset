`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg add_ascci;
    reg clk;
    reg reset_ascci;
    wire [3:0] n_ascci;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_ascci(add_ascci),
        .clk(clk),
        .reset_ascci(reset_ascci),
        .n_ascci(n_ascci)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        add_ascci = 0;
        reset_ascci = 1;
        @(posedge clk);
        #1;
        reset_ascci = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();


        #1;



        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Single Increment", test_num);
        reset_dut();
        add_ascci = 1;
        @(posedge clk);
        #1;
        add_ascci = 0;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Increment to 5", test_num);
        reset_dut();
        add_ascci = 1;
        repeat(5) @(posedge clk);
        #1;
        add_ascci = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Counter Overflow (16 cycles)", test_num);
        reset_dut();
        add_ascci = 1;
        repeat(16) @(posedge clk);
        #1;
        add_ascci = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Wrap around to 3", test_num);
        reset_dut();
        add_ascci = 1;
        repeat(19) @(posedge clk);
        #1;
        add_ascci = 0;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Stay idle when add_ascci is low", test_num);
        reset_dut();
        add_ascci = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Intermittent Increments", test_num);
        reset_dut();
        add_ascci = 1;
        repeat(2) @(posedge clk);
        #1;
        add_ascci = 0;
        repeat(3) @(posedge clk);
        #1;
        add_ascci = 1;
        repeat(2) @(posedge clk);
        #1;
        add_ascci = 0;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Mid-sequence Reset", test_num);
        reset_dut();
        add_ascci = 1;
        repeat(8) @(posedge clk);
        #1;
        reset_ascci = 1;
        @(posedge clk);
        #1;
        reset_ascci = 0;
        add_ascci = 0;
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_n_ascci;
        begin
            if (expected_n_ascci === (expected_n_ascci ^ n_ascci ^ expected_n_ascci)) begin
                $display("PASS");
                $display("  Outputs: n_ascci=%h",
                         n_ascci);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n_ascci=%h",
                         expected_n_ascci);
                $display("  Got:      n_ascci=%h",
                         n_ascci);
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
        $dumpvars(0,add_ascci, clk, reset_ascci, n_ascci);
    end

endmodule
