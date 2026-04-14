`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DACin;
    reg clk;
    wire DACout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DACin(DACin),
        .clk(clk),
        .DACout(DACout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DACin = 8'h00;
            repeat(256) @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            DACin = 8'h00;
            repeat(10) @(posedge clk);
            #2;
            $display("Testcase 001: Input 0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            DACin = 8'hFF;
            repeat(5) @(posedge clk);
            #2;
            $display("Testcase 002: Input 255");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            DACin = 8'h80;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 003: Input 128 (Cycle 2)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            DACin = 8'h40;
            repeat(4) @(posedge clk);
            #2;
            $display("Testcase 004: Input 64 (Cycle 4)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            DACin = 8'h01;
            repeat(255) @(posedge clk);
            #2;
            if (DACout === 1'b0) begin
                $display("Testcase 005 Part A: PASSED (Output low at cycle 255)");
                pass_count = pass_count + 1;
            } else {
                $display("Testcase 005 Part A: FAILED (Output high too early)");
                fail_count = fail_count + 1;
            }

            @(posedge clk);
            #2;
            $display("Testcase 005 Part B: Input 1 (Cycle 256)");
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
        input expected_DACout;
        begin
            if (expected_DACout === (expected_DACout ^ DACout ^ expected_DACout)) begin
                $display("PASS");
                $display("  Outputs: DACout=%b",
                         DACout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DACout=%b",
                         expected_DACout);
                $display("  Got:      DACout=%b",
                         DACout);
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
        $dumpvars(0,DACin, clk, DACout);
    end

endmodule
