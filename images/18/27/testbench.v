`timescale 1ns/1ps

module lfsr_32bit_tb;

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
    lfsr_32bit dut (
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

        begin
            reset = 1;
            repeat(2) @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Reset to Seed");
            test_num = 1;
            seed = 32'hACE0_BA5E;
            reset_dut();


            #1;



            check_outputs(32'hACE0_BA5E);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Single shift with feedback from MSB");
            test_num = 2;
            seed = 32'h8000_0000;
            reset_dut();
            @(posedge clk); #2;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Double shift transition");
            test_num = 3;
            seed = 32'h4000_0000;
            reset_dut();
            repeat(2) @(posedge clk); #2;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Multiple tap XOR logic");
            test_num = 4;
            seed = 32'h8021_1000;
            reset_dut();
            @(posedge clk); #2;
            #1;

            check_outputs(32'h0042_2000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: All bits high state");
            test_num = 5;
            seed = 32'hFFFF_FFFF;
            reset_dut();
            @(posedge clk); #2;
            #1;

            check_outputs(32'hFFFF_FFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
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
        $dumpvars(0,clk, reset, seed, lfsr_out);
    end

endmodule
