`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset = 1;
            #10;
            reset = 0;
            #2;
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            #2;
            test_num = 2;
            $display("Testcase %0d: State after 1 cycle (Expected 0001)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            #2;
            test_num = 3;
            $display("Testcase %0d: State after 2 cycles (Expected 0011)", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            test_num = 4;
            $display("Testcase %0d: State after 4 cycles (Expected 1111)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(4) @(posedge clk);
            #2;
            test_num = 5;
            $display("Testcase %0d: State after 5 cycles (Expected 1110)", test_num);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(6) @(posedge clk);
            #2;
            test_num = 6;
            $display("Testcase %0d: State after 7 cycles (Expected 1000)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            repeat(7) @(posedge clk);
            #2;
            test_num = 7;
            $display("Testcase %0d: State after 8 cycles (Expected back to 0000)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            repeat(3) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #2;
            test_num = 8;
            $display("Testcase %0d: Mid-sequence reset check", test_num);
            #1;

            check_outputs(4'b0000);
            reset = 0;
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, reset, count);
    end

endmodule
