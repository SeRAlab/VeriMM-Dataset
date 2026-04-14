`timescale 1ns/1ps

module lfsr_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg next;
    reg reset_n;
    wire [15:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_16bit dut (
        .clk(clk),
        .next(next),
        .reset_n(reset_n),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            next = 0;
            reset_n = 0;
            @(posedge clk);
            #1;
            reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Stall Check (next=0)", test_num);
            reset_dut();
            next = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Single Step Check", test_num);
            reset_dut();
            next = 1;
            @(posedge clk);
            #1;
            next = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Feedback Calculation Check (11 cycles)", test_num);
            reset_dut();
            next = 1;
            repeat (11) @(posedge clk);
            #1;
            next = 0;
            #1;

            check_outputs(16'h0801);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Long Sequence Check (16 cycles)", test_num);
            reset_dut();
            next = 1;
            repeat (16) @(posedge clk);
            #1;
            next = 0;
            #1;

            check_outputs(16'h0025);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Interrupted 'next' Check", test_num);
            reset_dut();
            next = 1;
            repeat (5) @(posedge clk);
            next = 0;
            repeat (5) @(posedge clk);
            next = 1;
            repeat (6) @(posedge clk);
            #1;
            next = 0;
            #1;

            check_outputs(16'h0801);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_16bit Testbench");
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
        $dumpvars(0,clk, next, reset_n, lfsr_out);
    end

endmodule
