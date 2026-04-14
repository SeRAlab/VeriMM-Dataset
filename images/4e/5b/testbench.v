`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] in0;
    reg [6:0] in1;
    reg [6:0] in2;
    reg [6:0] in3;
    reg resetload;
    wire [3:0] an;
    wire dp;
    wire [6:0] sseg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .resetload(resetload),
        .an(an),
        .dp(dp),
        .sseg(sseg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetload = 1;
            @(posedge clk);
            #2;
            resetload = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking State 0 (Initial state after reset)");
            in0 = 7'h01; in1 = 7'h02; in2 = 7'h04; in3 = 7'h08;
            reset_dut();

            #1;


            check_outputs(4'b1110, 1'b1, 7'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking transition to State 1");
            in0 = 7'h7E; in1 = 7'h30; in2 = 7'h6D; in3 = 7'h79;
            reset_dut();
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101, 1'b1, 7'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Checking transition to State 2");
            in0 = 7'h7E; in1 = 7'h30; in2 = 7'h6D; in3 = 7'h79;
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1011, 1'b1, 7'h6D);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Checking transition to State 3");
            in0 = 7'h7E; in1 = 7'h30; in2 = 7'h6D; in3 = 7'h79;
            reset_dut();
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0111, 1'b1, 7'h79);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Checking wrap around (State 3 -> State 0)");
            in0 = 7'h11; in1 = 7'h22; in2 = 7'h33; in3 = 7'h44;
            reset_dut();
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1110, 1'b1, 7'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Verify output updates when input changes in current state");
            in0 = 7'h00; in1 = 7'h10; in2 = 7'h20; in3 = 7'h30;
            reset_dut();
            repeat(2) @(posedge clk);
            #2;
            in2 = 7'h55;
            #2;
            #1;

            check_outputs(4'b1011, 1'b1, 7'h55);
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
        input [3:0] expected_an;
        input expected_dp;
        input [6:0] expected_sseg;
        begin
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp) &&
                expected_sseg === (expected_sseg ^ sseg ^ expected_sseg)) begin
                $display("PASS");
                $display("  Outputs: an=%h, dp=%b, sseg=%h",
                         an, dp, sseg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, dp=%b, sseg=%h",
                         expected_an, expected_dp, expected_sseg);
                $display("  Got:      an=%h, dp=%b, sseg=%h",
                         an, dp, sseg);
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
        $dumpvars(0,clk, in0, in1, in2, in3, resetload, an, dp, sseg);
    end

endmodule
