`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg enable;
    reg [15:0] i_in_ana;
    reg i_in_dig;
    reg [15:0] q_in_ana;
    reg q_in_dig;
    reg reset;
    wire [15:0] i_out;
    wire [15:0] q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .i_in_ana(i_in_ana),
        .i_in_dig(i_in_dig),
        .q_in_ana(q_in_ana),
        .q_in_dig(q_in_dig),
        .reset(reset),
        .i_out(i_out),
        .q_out(q_out)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: Enable=0 (Bypass)...");
            test_num = 1;
            reset = 1;
            enable = 0;
            i_in_ana = 16'hAAAA;
            q_in_ana = 16'h5555;
            i_in_dig = 1'b1;
            q_in_dig = 1'b1;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;

            check_outputs(16'hAAAA, 16'h5555);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Enable=1, Dig=0...");
            test_num = 2;
            reset = 1;
            enable = 1;
            i_in_ana = 16'h1234;
            q_in_ana = 16'h8001;
            i_in_dig = 1'b0;
            q_in_dig = 1'b0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;

            check_outputs(16'h2468, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Enable=1, Dig=1...");
            test_num = 3;
            reset = 1;
            enable = 1;
            i_in_ana = 16'h000F;
            q_in_ana = 16'h7000;
            i_in_dig = 1'b1;
            q_in_dig = 1'b1;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;

            check_outputs(16'h001F, 16'hE001);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Enable=1, Mixed Dig...");
            test_num = 4;
            reset = 1;
            enable = 1;
            i_in_ana = 16'hFFFF;
            q_in_ana = 16'hFFFF;
            i_in_dig = 1'b1;
            q_in_dig = 1'b0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;

            check_outputs(16'hFFFF, 16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: MSB Discard Check...");
            test_num = 5;
            reset = 1;
            enable = 1;
            i_in_ana = 16'h8000;
            q_in_ana = 16'hC000;
            i_in_dig = 1'b0;
            q_in_dig = 1'b1;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;

            check_outputs(16'h0000, 16'h8001);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Zero boundary...");
            test_num = 6;
            reset = 1;
            enable = 1;
            i_in_ana = 16'h0000;
            q_in_ana = 16'h0000;
            i_in_dig = 1'b0;
            q_in_dig = 1'b0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;

            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_i_out;
        input [15:0] expected_q_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_out === (expected_i_out ^ i_out ^ expected_i_out) &&
                expected_q_out === (expected_q_out ^ q_out ^ expected_q_out)) begin
                $display("PASS");
                $display("  Outputs: i_out=%h, q_out=%h",
                         i_out, q_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_out=%h, q_out=%h",
                         expected_i_out, expected_q_out);
                $display("  Got:      i_out=%h, q_out=%h",
                         i_out, q_out);
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

endmodule
