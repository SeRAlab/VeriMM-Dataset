`timescale 1ns/1ps

module LFSR_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] seed;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR_32bit dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [31:0] s;
        begin
            seed = s;
            reset = 1;
            @(negedge clk);
            reset = 0;

            #1;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut(32'hACE12468);
            $display("Testcase 001: Testing Reset and Seed Loading (0xACE12468)");
            #1;

            check_outputs(32'hACE12468);
        end
        endtask

    task testcase002;

        begin
            reset_dut(32'h80000000);
            @(posedge clk);
            #1;
            $display("Testcase 002: Single Shift from 0x80000000");
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            reset_dut(32'h00000001);
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase 003: 5 Cycles from Seed 0x1");
            #1;

            check_outputs(32'h00000036);
        end
        endtask

    task testcase004;

        begin
            reset_dut(32'hFFFFFFFF);
            @(posedge clk);
            #1;
            $display("Testcase 004: All-Ones Seed Single Shift");
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut(32'hDEADBEEF);
            @(posedge clk);
            #1;
            $display("Testcase 005: Custom Seed 0xDEADBEEF Single Shift");
            #1;

            check_outputs(32'hBD5B7DDE);
        end
        endtask

    task testcase006;

        begin
            reset_dut(32'h00200000);
            @(posedge clk);
            #1;
            $display("Testcase 006: Bit 21 Tap Verification");
            #1;

            check_outputs(32'h00400001);
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
        $dumpvars(0,clk, reset, seed, lfsr_out);
    end

endmodule
