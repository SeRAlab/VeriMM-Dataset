`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg reset;
    reg set;
    wire q;
    wire q_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .set(set),
        .q(q),
        .q_n(q_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset <= 1;
            set <= 0;
            data <= 0;
            @(posedge clk);
            #1;
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Synchronous Reset", test_num);
            @(posedge clk);
            data <= 1;
            set <= 0;
            reset <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Synchronous Set", test_num);
            @(posedge clk);
            data <= 0;
            set <= 1;
            reset <= 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Simultaneous Set and Reset", test_num);
            @(posedge clk);
            data <= 1;
            set <= 1;
            reset <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Data Passthrough (Logic High)", test_num);
            @(posedge clk);
            data <= 1;
            set <= 0;
            reset <= 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Data Passthrough (Logic Low)", test_num);
            @(posedge clk);
            data <= 0;
            set <= 0;
            reset <= 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Data Transition High to Low", test_num);
            @(posedge clk);
            data <= 1; set <= 0; reset <= 0;
            @(posedge clk);
            data <= 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
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
        input expected_q;
        input expected_q_n;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_n === (expected_q_n ^ q_n ^ expected_q_n)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_n=%b",
                         q, q_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_n=%b",
                         expected_q, expected_q_n);
                $display("  Got:      q=%b, q_n=%b",
                         q, q_n);
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
        $dumpvars(0,clk, data, reset, set, q, q_n);
    end

endmodule
