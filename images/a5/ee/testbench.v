`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg data;
    reg reset;
    wire [3:0] count;
    wire counting;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .clk(clk),
        .data(data),
        .reset(reset),
        .count(count),
        .counting(counting),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            data = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task send_start_seq;

        begin
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning Testcase 001: Data=0000 (1000 cycles)");
            reset_dut();
            send_start_seq();

            repeat(4) send_bit(0);


            if (counting !== 1) $display("Error: counting signal not high");


            repeat(1000) @(posedge clk);
            #2;


            #1;



            check_outputs(4'h0, 1'b0, 1'b1);


            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Data=0001 (2000 cycles)");
            reset_dut();
            send_start_seq();
            send_bit(0); send_bit(0); send_bit(0); send_bit(1);


            repeat(1000) @(posedge clk);

            if (counting !== 1 || done !== 0) $display("Error: Finished too early");


            repeat(1000) @(posedge clk);
            #2;

            #1;


            check_outputs(4'h1, 1'b0, 1'b1);

            ack = 1; @(posedge clk); ack = 0;
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Reset during counting");
            reset_dut();

            send_bit(1); send_bit(1); send_bit(1);
            if (counting !== 0) $display("Error: counting started on wrong sequence");


            send_start_seq();
            repeat(4) send_bit(1);

            repeat(100) @(posedge clk);
            if (counting !== 1) $display("Error: Not counting");


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Consecutive Operations");
            reset_dut();


            send_start_seq();
            repeat(4) send_bit(0);
            repeat(1000) @(posedge clk);
            #2;
            if (done !== 1) $display("Error: First run failed");


            ack = 1; @(posedge clk); ack = 0;
            @(posedge clk);


            send_start_seq();
            repeat(4) send_bit(0);
            repeat(1000) @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 1'b0, 1'b1);

            ack = 1; @(posedge clk); ack = 0;
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
        input [3:0] expected_count;
        input expected_counting;
        input expected_done;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_counting === (expected_counting ^ counting ^ expected_counting) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: count=%h, counting=%b, done=%b",
                         count, counting, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, counting=%b, done=%b",
                         expected_count, expected_counting, expected_done);
                $display("  Got:      count=%h, counting=%b, done=%b",
                         count, counting, done);
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
        $dumpvars(0,ack, clk, data, reset, count, counting, done);
    end

endmodule
