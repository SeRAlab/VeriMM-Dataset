`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] amount;
    reg clk;
    reg [63:0] data;
    reg ena;
    reg load;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amount(amount),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            ena = 0;
            data = 64'h0;
            amount = 3'b000;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Load");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'hFEDCBA9876543210;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift Left by 1 (amount 000)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h0000000000000001;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left by 8 (amount 001)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h00000000000000FF;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h000000000000FF00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Left by 16 (amount 010)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h000000000000FFFF;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000FFFF0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Right by 1 (amount 100)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h0000000000000002;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Right by 8 (amount 101)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h000000000000FF00;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000000000FF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift Right by 16 (amount 110)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h00000000FFFF0000;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h000000000000FFFF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable Low Verification");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'hCAFEBABECAFEBABE;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 0;
            amount = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hCAFEBABECAFEBABE);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Shift out MSB");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h8000000000000000;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Sequential shifts");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 64'h1;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            ena = 1;
            amount = 3'b001;
            @(posedge clk);
            @(negedge clk);
            amount = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000001000000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [63:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,amount, clk, data, ena, load, q);
    end

endmodule
