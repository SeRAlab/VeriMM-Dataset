`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [2:0] q;

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
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;
            $display("Test Case 001: Post-Reset State");
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            $display("Test Case 002: State after 1 cycle");
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case 003: State after 2 cycles");
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            $display("Test Case 004: State after 3 cycles");
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 005: State after 4 cycles");
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 006: State after 5 cycles");
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            $display("Test Case 007: State after 6 cycles (Full cycle)");
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            repeat(3) @(posedge clk);
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
            $display("Test Case 008: Synchronous Reset mid-count");
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_q;
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
