`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    wire [1:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        integer timeout;
        begin
            timeout = 0;

            while (count_out !== 2'b00 && timeout < 5) begin
                @(posedge clk_in);
                #1;
                timeout = timeout + 1;
            end

            if (count_out !== 2'b00) begin

                @(posedge clk_in);
                #1;
            end
            $display("--- Resetting DUT to state 00 ---");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Initial state after reset", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk_in);
            #1;
            $display("Test %0d: State after 1 clock pulse", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk_in);
            #1;
            $display("Test %0d: State after 2 clock pulses", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk_in);
            #1;
            $display("Test %0d: State after 3 clock pulses (Rollover)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk_in);
            #1;
            $display("Test %0d: State after 4 clock pulses (Wrap back to 1)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(6) @(posedge clk_in);
            #1;
            $display("Test %0d: State after 6 clock pulses (Multiple rollovers)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(8) @(posedge clk_in);
            #1;
            $display("Test %0d: State after 8 clock pulses", test_num);
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clk_in, count_out);
    end

endmodule
