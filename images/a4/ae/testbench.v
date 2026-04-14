`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sreset;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sreset(sreset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        sreset = 1;
        @(posedge clk);
        sreset = 0;


    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial Reset", test_num);
        reset_dut();
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Decrement by 1", test_num);
        reset_dut();
        @(posedge clk);
        #1;

        check_outputs(6'd62);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Decrement by 31 cycles", test_num);
        reset_dut();
        repeat(31) @(posedge clk);
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Decrement to 0", test_num);
        reset_dut();
        repeat(63) @(posedge clk);
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Wrap around check (0 to 63)", test_num);
        reset_dut();
        repeat(64) @(posedge clk);
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Wrap around plus offset", test_num);
        reset_dut();
        repeat(70) @(posedge clk);

        #1;


        check_outputs(6'd57);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Mid-operation synchronous reset", test_num);
        reset_dut();
        repeat(20) @(posedge clk);
        @(posedge clk) sreset = 1;
        @(posedge clk) sreset = 0;
        #1;

        check_outputs(6'd63);
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
        input [5:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, sreset, count);
    end

endmodule
