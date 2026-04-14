`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    reg valid_in;
    wire data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            data_in = 0;
            repeat (5) @(posedge clk);
            reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'bx, 0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            valid_in = 1;
            data_in = 0;

            for (i = 0; i < 64; i = i + 1) begin
                data_in = 0;
                @(posedge clk);
            end
            valid_in = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            valid_in = 1;

            for (i = 0; i < 64; i = i + 1) begin
                data_in = 1;
                @(posedge clk);
            end
            valid_in = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();

            valid_in = 1; data_in = 0; @(posedge clk);

            valid_in = 0; repeat(5) @(posedge clk);

            valid_in = 1; data_in = 1; @(posedge clk);

            valid_in = 0; repeat(5) @(posedge clk);


            valid_in = 1;
            for (i = 0; i < 60; i = i + 1) begin
                data_in = (i % 2);
                @(posedge clk);
            end
            valid_in = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(data_out, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            valid_in = 1;
            data_in = 1;
            repeat(5) @(posedge clk);
            reset_dut();
            #1;

            check_outputs(1'bx, 0);
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
        input expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%b, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, data_out, valid_out);
    end

endmodule
