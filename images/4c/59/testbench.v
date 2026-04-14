`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
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

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Synchronous Reset to 0000", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: State 1 (1000)", test_num);
            reset_dut();
            @(posedge clk); #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: State 2 (1100)", test_num);
            reset_dut();
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: State 3 (1110)", test_num);
            reset_dut();
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: State 4 (1111)", test_num);
            reset_dut();
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: State 5 (0111)", test_num);
            reset_dut();
            repeat(5) @(posedge clk); #1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: State 6 (0011)", test_num);
            reset_dut();
            repeat(6) @(posedge clk); #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: State 7 (0001)", test_num);
            reset_dut();
            repeat(7) @(posedge clk); #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Full wrap around to State 0 (0000)", test_num);
            reset_dut();
            repeat(8) @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Verify sequence at 1.5 cycles (1111)", test_num);
            reset_dut();
            repeat(12) @(posedge clk); #1;
            #1;

            check_outputs(4'b1111);
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
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,clk, reset, q);
    end

endmodule
