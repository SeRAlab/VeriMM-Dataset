`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [3:0] count_out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .count_out(count_out),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Post-reset state...");
            reset_dut();




            #1;





            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Increment once...");
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Increment to 7...");
            reset_dut();
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overflow detection at 15...");
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Wrap-around logic...");
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Wrap-around increment to 1...");
            reset_dut();
            repeat(17) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Two full cycles (32 increments)...");
            reset_dut();
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_count_out;
        input expected_overflow;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, overflow=%b",
                         count_out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, overflow=%b",
                         expected_count_out, expected_overflow);
                $display("  Got:      count_out=%h, overflow=%b",
                         count_out, overflow);
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
        $dumpvars(0,clk, rst, count_out, overflow);
    end

endmodule
