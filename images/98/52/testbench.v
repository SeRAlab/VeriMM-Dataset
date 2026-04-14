`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg reset;
    wire fall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .fall(fall)
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
            in <= 0;
            @(posedge clk);
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Detection of 1 to 0 transition");
            reset_dut();
            @(negedge clk);
            in = 1;
            @(posedge clk);
            @(negedge clk);
            in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: No detection on 0 to 1 transition");
            reset_dut();
            @(negedge clk);
            in = 0;
            @(posedge clk);
            @(negedge clk);
            in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: No detection on constant high");
            reset_dut();
            @(negedge clk);
            in = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: No detection on constant low");
            reset_dut();
            @(negedge clk);
            in = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Reset suppression during falling edge");
            reset_dut();
            @(negedge clk);
            in = 1;
            @(posedge clk);
            @(negedge clk);
            in = 0;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Multiple falling edges");
            reset_dut();

            @(negedge clk);
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);

            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: One-cycle pulse high");
            reset_dut();
            @(negedge clk);
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_fall;
        begin
            if (expected_fall === (expected_fall ^ fall ^ expected_fall)) begin
                $display("PASS");
                $display("  Outputs: fall=%b",
                         fall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fall=%b",
                         expected_fall);
                $display("  Got:      fall=%b",
                         fall);
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
        $dumpvars(0,clk, in, reset, fall);
    end

endmodule
