`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg mode;
    reg reset;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .mode(mode),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        mode = 0;
        data_in = 0;
        #2;
        reset = 0;
        #8;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Asynchronous Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Synchronous Load Check", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 4'hA;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Increment Counter Check", test_num);
        reset_dut();
        @(negedge clk);
        mode = 1;
        load = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Decrement Counter Check (from loaded value)", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 4'h8;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        mode = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Upward Wrap-around Check (F to 0)", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 4'hF;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        mode = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Downward Wrap-around Check (0 to F)", test_num);
        reset_dut();

        @(negedge clk);
        mode = 0;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Priority Check (Load should override mode)", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 4'h3;
        load = 1;
        mode = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Complex Sequence (Up, Down, Load, Down)", test_num);
        reset_dut();
        @(negedge clk);
        mode = 1;
        @(posedge clk);
        #1 mode = 1;
        @(posedge clk);
        #1 mode = 0;
        @(posedge clk);
        #1 data_in = 4'hE; load = 1;
        @(posedge clk);
        #1 load = 0; mode = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hD);
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data_in, load, mode, reset, result);
    end

endmodule
