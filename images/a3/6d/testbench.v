`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg data;
    reg done_counting;
    reg reset;
    wire counting;
    wire done;
    wire shift_ena;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .clk(clk),
        .data(data),
        .done_counting(done_counting),
        .reset(reset),
        .counting(counting),
        .done(done),
        .shift_ena(shift_ena)
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
            ack = 0;
            data = 0;
            done_counting = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);

            repeat(4) @(posedge clk);

            done_counting = 1; @(posedge clk);

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);

            repeat(4) @(posedge clk);

            done_counting = 0;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);

            @(posedge clk);

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            data = 1; @(posedge clk); data = 1; @(posedge clk); data = 0; @(posedge clk); data = 1; @(posedge clk);
            repeat(4) @(posedge clk);
            done_counting = 1; @(posedge clk);

            ack = 1; @(posedge clk);

            #1;


            check_outputs(0, 0, 0);
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
        input expected_counting;
        input expected_done;
        input expected_shift_ena;
        begin
            if (expected_counting === (expected_counting ^ counting ^ expected_counting) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_shift_ena === (expected_shift_ena ^ shift_ena ^ expected_shift_ena)) begin
                $display("PASS");
                $display("  Outputs: counting=%b, done=%b, shift_ena=%b",
                         counting, done, shift_ena);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counting=%b, done=%b, shift_ena=%b",
                         expected_counting, expected_done, expected_shift_ena);
                $display("  Got:      counting=%b, done=%b, shift_ena=%b",
                         counting, done, shift_ena);
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
        $dumpvars(0,ack, clk, data, done_counting, reset, counting, done, shift_ena);
    end

endmodule
