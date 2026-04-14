`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] config_in;
    reg config_in_valid;
    reg credit_in_valid;
    reg decrement;
    reg enable;
    reg reset;
    reg sim_time_tick;
    wire [3:0] config_out;
    wire config_out_valid;
    wire [3:0] count_out;
    wire credit_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .config_in(config_in),
        .config_in_valid(config_in_valid),
        .credit_in_valid(credit_in_valid),
        .decrement(decrement),
        .enable(enable),
        .reset(reset),
        .sim_time_tick(sim_time_tick),
        .config_out(config_out),
        .config_out_valid(config_out_valid),
        .count_out(count_out),
        .credit_ack(credit_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            config_in = 0;
            config_in_valid = 0;
            credit_in_valid = 0;
            decrement = 0;
            sim_time_tick = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0, 0, 4'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            config_in = 4'hA;
            config_in_valid = 1;
            @(posedge clock);
            #1;
            config_in_valid = 0;

            #1;


            check_outputs(4'hA, 1, 4'hA, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            config_in = 4'h5;
            config_in_valid = 1;
            @(posedge clock);
            #1;
            config_in_valid = 0;
            enable = 1;
            sim_time_tick = 1;

            credit_in_valid = 1;
            decrement = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'h5, 1, 4'h6, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            config_in = 4'h8;
            config_in_valid = 1;
            @(posedge clock);
            #1;
            config_in_valid = 0;
            enable = 1;
            sim_time_tick = 1;

            credit_in_valid = 1;
            decrement = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'h8, 1, 4'h7, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            config_in = 4'h2;
            config_in_valid = 1;
            @(posedge clock);
            #1;
            config_in_valid = 0;
            enable = 1;
            sim_time_tick = 1;

            credit_in_valid = 1;
            decrement = 0;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'h2, 1, 4'h4, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            config_in = 4'h5;
            config_in_valid = 1;
            @(posedge clock);
            #1;
            config_in_valid = 0;
            enable = 0;
            credit_in_valid = 1;
            decrement = 0;
            @(posedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'h5, 1, 4'h5, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            config_in = 4'hF;
            config_in_valid = 1;
            @(posedge clock);
            #1;
            config_in_valid = 0;
            enable = 1;
            sim_time_tick = 1;
            credit_in_valid = 1;
            decrement = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'hF, 1, 4'h0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            config_in = 4'h0;
            config_in_valid = 1;
            @(posedge clock);
            #1;
            config_in_valid = 0;
            enable = 1;
            sim_time_tick = 1;
            credit_in_valid = 1;
            decrement = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'h0, 1, 4'hF, 1);
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
        input [3:0] expected_config_out;
        input expected_config_out_valid;
        input [3:0] expected_count_out;
        input expected_credit_ack;
        begin
            if (expected_config_out === (expected_config_out ^ config_out ^ expected_config_out) &&
                expected_config_out_valid === (expected_config_out_valid ^ config_out_valid ^ expected_config_out_valid) &&
                expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_credit_ack === (expected_credit_ack ^ credit_ack ^ expected_credit_ack)) begin
                $display("PASS");
                $display("  Outputs: config_out=%h, config_out_valid=%b, count_out=%h, credit_ack=%b",
                         config_out, config_out_valid, count_out, credit_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: config_out=%h, config_out_valid=%b, count_out=%h, credit_ack=%b",
                         expected_config_out, expected_config_out_valid, expected_count_out, expected_credit_ack);
                $display("  Got:      config_out=%h, config_out_valid=%b, count_out=%h, credit_ack=%b",
                         config_out, config_out_valid, count_out, credit_ack);
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
        $dumpvars(0,clock, config_in, config_in_valid, credit_in_valid, decrement, enable, reset, sim_time_tick, config_out, config_out_valid, count_out, credit_ack);
    end

endmodule
