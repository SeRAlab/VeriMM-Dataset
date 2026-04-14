`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    reg write;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .write(write),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            write = 0;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Verification of Asynchronous Reset");
            reset = 1;
            #2;
            #1;

            check_outputs(0);
            reset = 0;
            #8;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Write 1 on Negative Edge");
            reset_dut();
            @(posedge clk);
            d = 1;
            write = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Write 0 on Negative Edge");

            @(posedge clk);
            d = 1; write = 1;
            @(negedge clk);
            #2;

            @(posedge clk);
            d = 0;
            write = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Write Enable Hold functionality");
            reset_dut();

            @(posedge clk);
            d = 1; write = 1;
            @(negedge clk);
            #2;

            @(posedge clk);
            d = 0;
            write = 0;
            @(negedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Reset priority over Write Enable");
            reset_dut();
            @(posedge clk);
            d = 1;
            write = 1;
            reset = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Verify no change on Positive Edge");
            reset_dut();
            d = 1;
            write = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
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
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
        $dumpvars(0,clk, d, reset, write, q);
    end

endmodule
