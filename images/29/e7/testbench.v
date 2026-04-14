`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [15:0] lfsr_out;

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
        end
        endtask
    task testcase001;

        begin
            $display("testcase001: Checking Reset Seed (0xACE1)");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(16'hACE1);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Checking Shift after 1 Cycle (0x59C3)");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h59C3);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Checking Shift after 2 Cycles (0xB386)");
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hB386);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Checking Shift after 5 Cycles (0x9C34)");
            test_num = 4;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h9C34);
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Checking Shift after 10 Cycles (0x8690)");
            test_num = 5;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8690);
        end
        endtask

    task testcase006;

        begin
            $display("testcase006: Checking Reset Recovery from Mid-Sequence");
            test_num = 6;
            reset_dut();
            repeat(20) @(posedge clk);
            reset_dut();
            #1;

            check_outputs(16'hACE1);
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
        input [15:0] expected_lfsr_out;
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
