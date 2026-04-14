`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg nreset;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .nreset(nreset),
        .detected(detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nreset = 0;
            in = 0;
            #15;
            nreset = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic 1010 detection");
            reset_dut();
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Incorrect sequence 1011");
            reset_dut();
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Leading zeros 0001010");
            reset_dut();
            @(negedge clk) in = 0;
            @(negedge clk) in = 0;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Overlapping sequence 101010");
            reset_dut();
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Incomplete sequence 101");
            reset_dut();
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Broken then correct sequence");
            reset_dut();
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Continuous ones");
            reset_dut();
            @(negedge clk) in = 1;
            @(negedge clk) in = 1;
            @(negedge clk) in = 1;
            @(negedge clk) in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Sequence after reset during operation");
            reset_dut();
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;

            nreset = 0; #5; nreset = 1;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(posedge clk);
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
        input expected_detected;
        begin
            if (expected_detected === (expected_detected ^ detected ^ expected_detected)) begin
                $display("PASS");
                $display("  Outputs: detected=%b",
                         detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected=%b",
                         expected_detected);
                $display("  Got:      detected=%b",
                         detected);
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
        $dumpvars(0,clk, in, nreset, detected);
    end

endmodule
