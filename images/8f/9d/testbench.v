`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    wire q;
    wire q_delayed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .q(q),
        .q_delayed(q_delayed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            d = 1;
            @(posedge clk);


            d = 0;
            @(posedge clk);


            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            d = 1;
            @(posedge clk);
            @(posedge clk);
            d = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            d = 1;
            @(posedge clk);
            @(posedge clk);


            d = 0;
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);

            #1;

            #1;


            check_outputs(0, 0);
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
        input expected_q;
        input expected_q_delayed;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_delayed === (expected_q_delayed ^ q_delayed ^ expected_q_delayed)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_delayed=%b",
                         q, q_delayed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_delayed=%b",
                         expected_q, expected_q_delayed);
                $display("  Got:      q=%b, q_delayed=%b",
                         q, q_delayed);
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
        $dumpvars(0,clk, d, q, q_delayed);
    end

endmodule
