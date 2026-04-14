`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg en;
    reg pre_first_in;
    wire pre_first_out;
    wire [7:0] y_out;
    wire [7:0] yaddr;
    wire ywe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .en(en),
        .pre_first_in(pre_first_in),
        .pre_first_out(pre_first_out),
        .y_out(y_out),
        .yaddr(yaddr),
        .ywe(ywe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            din = 0;
            pre_first_in = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Pure White Pixel");
            reset_dut();
            @(posedge clk);
            en = 1; pre_first_in = 1; din = 8'hFF;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'hFF;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'hFF;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(1'b1, 8'hFF, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Pure Black Pixel");
            reset_dut();
            @(posedge clk);
            en = 1; pre_first_in = 1; din = 8'h00;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h00;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h00;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(1'b1, 8'h00, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Pure Red Pixel");
            reset_dut();
            @(posedge clk);
            en = 1; pre_first_in = 1; din = 8'hFF;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h00;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h00;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(1'b1, 8'd76, 8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Pure Green Pixel");
            reset_dut();
            @(posedge clk);
            en = 1; pre_first_in = 1; din = 8'h00;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'hFF;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h00;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(1'b1, 8'd149, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Pure Blue Pixel");
            reset_dut();
            @(posedge clk);
            en = 1; pre_first_in = 1; din = 8'h00;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h00;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'hFF;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(1'b1, 8'd28, 8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Sequential Pixels (Address Check)");
            reset_dut();
            @(posedge clk);

            en = 1; pre_first_in = 1; din = 8'hFF;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'hFF;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'hFF;

            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h80;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h80;
            @(posedge clk);
            en = 1; pre_first_in = 0; din = 8'h80;

            @(posedge clk);
            en = 0;
            #1;

            check_outputs(1'b0, 8'd128, 8'h01, 1'b1);
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
        input expected_pre_first_out;
        input [7:0] expected_y_out;
        input [7:0] expected_yaddr;
        input expected_ywe;
        begin
            if (expected_pre_first_out === (expected_pre_first_out ^ pre_first_out ^ expected_pre_first_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out) &&
                expected_yaddr === (expected_yaddr ^ yaddr ^ expected_yaddr) &&
                expected_ywe === (expected_ywe ^ ywe ^ expected_ywe)) begin
                $display("PASS");
                $display("  Outputs: pre_first_out=%b, y_out=%h, yaddr=%h, ywe=%b",
                         pre_first_out, y_out, yaddr, ywe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pre_first_out=%b, y_out=%h, yaddr=%h, ywe=%b",
                         expected_pre_first_out, expected_y_out, expected_yaddr, expected_ywe);
                $display("  Got:      pre_first_out=%b, y_out=%h, yaddr=%h, ywe=%b",
                         pre_first_out, y_out, yaddr, ywe);
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
        $dumpvars(0,clk, din, en, pre_first_in, pre_first_out, y_out, yaddr, ywe);
    end

endmodule
