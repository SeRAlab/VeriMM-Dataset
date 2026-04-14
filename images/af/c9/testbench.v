`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] PR_new_flush;
    reg [5:0] PR_old;
    reg RegDest;
    reg RegDest_ROB;
    reg RegDest_retire;
    reg clk;
    reg hazard_stall;
    reg recover;
    reg retire_reg;
    reg rst;
    wire [5:0] PR_new;
    wire empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PR_new_flush(PR_new_flush),
        .PR_old(PR_old),
        .RegDest(RegDest),
        .RegDest_ROB(RegDest_ROB),
        .RegDest_retire(RegDest_retire),
        .clk(clk),
        .hazard_stall(hazard_stall),
        .recover(recover),
        .retire_reg(retire_reg),
        .rst(rst),
        .PR_new(PR_new),
        .empty(empty)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            PR_new_flush = 0;
            PR_old = 0;
            RegDest = 0;
            RegDest_ROB = 0;
            RegDest_retire = 0;
            hazard_stall = 0;
            recover = 0;
            retire_reg = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State");
            reset_dut();


            #1;



            check_outputs(PR_new, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Retirement Push");
            reset_dut();
            @(posedge clk);
            #1;
            PR_old = 6'd10;
            RegDest_retire = 1;
            retire_reg = 1;
            @(posedge clk);
            #1;
            RegDest_retire = 0;
            retire_reg = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd10, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple Pushes (FIFO ordering)");
            reset_dut();
            @(posedge clk); #1;
            PR_old = 6'd20; RegDest_retire = 1; retire_reg = 1;
            @(posedge clk); #1;
            PR_old = 6'd21;
            @(posedge clk); #1;
            PR_old = 6'd22;
            @(posedge clk); #1;
            retire_reg = 0; RegDest_retire = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(6'd20, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Allocation (Pop)");
            reset_dut();

            @(posedge clk); #1;
            PR_old = 6'd30; RegDest_retire = 1; retire_reg = 1;
            @(posedge clk); #1;
            PR_old = 6'd31;
            @(posedge clk); #1;
            retire_reg = 0; RegDest_retire = 0;
            @(posedge clk); #1;

            RegDest = 1;
            @(posedge clk); #1;
            RegDest = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(6'd31, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Recovery Flush Push");
            reset_dut();
            @(posedge clk); #1;
            PR_new_flush = 6'd45;
            RegDest_ROB = 1;
            recover = 1;
            @(posedge clk); #1;
            RegDest_ROB = 0;
            recover = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(6'd45, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Allocation with Hazard Stall");
            reset_dut();

            @(posedge clk); #1;
            PR_old = 6'd50; RegDest_retire = 1; retire_reg = 1;
            @(posedge clk); #1;
            retire_reg = 0; RegDest_retire = 0;
            @(posedge clk); #1;

            RegDest = 1;
            hazard_stall = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(6'd50, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Empty after Pop");
            reset_dut();
            @(posedge clk); #1;
            PR_old = 6'd5; RegDest_retire = 1; retire_reg = 1;
            @(posedge clk); #1;
            retire_reg = 0; RegDest_retire = 0;
            RegDest = 1;
            @(posedge clk); #1;
            RegDest = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(PR_new, 1'b1);
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
        testcase007();
        
        
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
        input [5:0] expected_PR_new;
        input expected_empty;
        begin
            if (expected_PR_new === (expected_PR_new ^ PR_new ^ expected_PR_new) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: PR_new=%h, empty=%b",
                         PR_new, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PR_new=%h, empty=%b",
                         expected_PR_new, expected_empty);
                $display("  Got:      PR_new=%h, empty=%b",
                         PR_new, empty);
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
        $dumpvars(0,PR_new_flush, PR_old, RegDest, RegDest_ROB, RegDest_retire, clk, hazard_stall, recover, retire_reg, rst, PR_new, empty);
    end

endmodule
