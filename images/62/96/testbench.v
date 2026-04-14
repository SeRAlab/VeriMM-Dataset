`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 4'b0000;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Standard detection sequence...");
            reset_dut();
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Incomplete sequence...");
            reset_dut();
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Mismatch at IDLE state...");
            reset_dut();
            @(negedge clk) data_in = 4'b1111;
            @(negedge clk) data_in = 4'b1010;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mismatch at S1 resets sequence...");
            reset_dut();
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b0000;
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Mismatch at S2 resets sequence...");
            reset_dut();
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b0000;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple consecutive matches...");
            reset_dut();
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Manual reset mid-sequence...");
            reset_dut();
            @(negedge clk) data_in = 4'b1010;
            @(negedge clk) data_in = 4'b1010;
            reset = 1; #10; reset = 0;
            @(negedge clk) data_in = 4'b1010;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
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
        input expected_match;
        begin
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
        $dumpvars(0,clk, data_in, reset, match);
    end

endmodule
