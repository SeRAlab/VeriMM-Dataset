`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [4:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .rst(rst),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Checking Reset State...");
            reset_dut();
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Checking state after 1 clock cycle...");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Checking state after 5 clock cycles...");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Checking state after 10 clock cycles...");
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h13);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Checking periodicity (31 cycles)...");
            reset_dut();
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase006;

        integer i;
        reg stuck_at_zero;
        begin
            $display("\nTestcase 006: Verifying non-zero progression...");
            reset_dut();
            stuck_at_zero = 0;
            for (i = 0; i < 32; i = i + 1) begin
                if (lfsr_out == 5'h00) stuck_at_zero = 1;
                @(posedge clk);
                #1;
            end

            if (!stuck_at_zero) begin
                $display("PASS: No zero state detected in full cycle.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: LFSR entered zero state.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [4:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, rst, lfsr_out);
    end

endmodule
