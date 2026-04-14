`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [17:0] n;
    reg reset_n;
    reg run;
    wire [17:0] n_pow_5;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .n(n),
        .reset_n(reset_n),
        .run(run),
        .n_pow_5(n_pow_5),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_n = 0;
            run = 0;
            n = 0;
            repeat(2) @(posedge clock);
            #1 reset_n = 1;
            repeat(2) @(posedge clock);
        end
        endtask
    task run_test;

        input [17:0] input_val;
        reg [89:0] full_result;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input n = %d", test_num, input_val);

            n = input_val;
            @(posedge clock);
            #1 run = 1;
            @(posedge clock);
            #1 run = 0;



            wait(ready === 1);


            @(posedge clock);
            #1;


            full_result = input_val;
            full_result = full_result * input_val * input_val * input_val * input_val;

            #1;


            check_outputs(full_result[17:0], 1'b1);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_test(18'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_test(18'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_test(18'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_test(18'd10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_test(18'd15);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_test(18'd64);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_test(18'd12);
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
        input [17:0] expected_n_pow_5;
        input expected_ready;
        begin
            if (expected_n_pow_5 === (expected_n_pow_5 ^ n_pow_5 ^ expected_n_pow_5) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: n_pow_5=%h, ready=%b",
                         n_pow_5, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n_pow_5=%h, ready=%b",
                         expected_n_pow_5, expected_ready);
                $display("  Got:      n_pow_5=%h, ready=%b",
                         n_pow_5, ready);
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
        $dumpvars(0,clock, n, reset_n, run, n_pow_5, ready);
    end

endmodule
