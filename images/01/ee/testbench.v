`timescale 1ns/1ps

module LFSR_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] seed;
    wire [4:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [4:0] initial_seed;
        begin
            rst = 1;
            seed = initial_seed;
            @(posedge clk);
            #1 rst = 0;


        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Seed=5'h1F, 5 cycles...");
            reset_dut(5'h1F);
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);

        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Seed=5'h01, 4 cycles...");
            reset_dut(5'h01);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h11);

        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Seed=5'h0A, 2 cycles...");
            reset_dut(5'h0A);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0B);

        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Seed=5'h10, 1 cycle...");
            reset_dut(5'h10);
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);

        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Seed=5'h08, 6 cycles...");
            reset_dut(5'h08);
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h12);

        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR Testbench");
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
        $dumpvars(0,clk, rst, seed, lfsr_out);
    end

endmodule
