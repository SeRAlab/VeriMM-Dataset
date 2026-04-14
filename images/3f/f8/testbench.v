`timescale 1ns/1ps

module LFSR_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR_32bit dut (
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
            #1 rst = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Initial Reset State Check", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Single Clock Shift", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Running Testcase%03d: 12 Cycles (Pre-Feedback Influence)", test_num);
            reset_dut();
            for(i=0; i<11; i=i+1) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Running Testcase%03d: First Feedback Trigger (Tap 13)", test_num);
            reset_dut();
            for(i=0; i<12; i=i+1) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00002001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Running Testcase%03d: Feedback Trigger (Tap 16)", test_num);
            reset_dut();
            for(i=0; i<15; i=i+1) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00010009);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR_32bit Testbench");
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
        input [31:0] expected_lfsr_out;
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
