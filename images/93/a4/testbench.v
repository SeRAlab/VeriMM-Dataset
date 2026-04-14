`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    wire [7:0] average;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .average(average)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;
            repeat (8) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 001: All Zeros");
            repeat (8) begin
                d = 8'h00;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 002: All Max Values (255)");
            repeat (8) begin
                d = 8'hFF;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 003: Ramp 1-8");
            d = 8'd1; @(posedge clk);
            d = 8'd2; @(posedge clk);
            d = 8'd3; @(posedge clk);
            d = 8'd4; @(posedge clk);
            d = 8'd5; @(posedge clk);
            d = 8'd6; @(posedge clk);
            d = 8'd7; @(posedge clk);
            d = 8'd8; @(posedge clk);
            #2;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 004: Mixed Alternating 100 and 50");
            repeat (4) begin
                d = 8'd100; @(posedge clk);
                d = 8'd50;  @(posedge clk);
            end
            #2;

            #1;


            check_outputs(8'd75);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 005: Single 128 Pulse");
            d = 8'd0;   @(posedge clk);
            d = 8'd0;   @(posedge clk);
            d = 8'd0;   @(posedge clk);
            d = 8'd0;   @(posedge clk);
            d = 8'd0;   @(posedge clk);
            d = 8'd0;   @(posedge clk);
            d = 8'd0;   @(posedge clk);
            d = 8'd128; @(posedge clk);
            #2;

            #1;


            check_outputs(8'd16);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 006: Division Floor Check");
            repeat (7) begin
                d = 8'd0; @(posedge clk);
            end
            d = 8'd7; @(posedge clk);
            #2;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 007: Shift Persistence");
            d = 8'd80; @(posedge clk);
            repeat (7) begin
                d = 8'd0; @(posedge clk);
            end
            #2;

            #1;


            check_outputs(8'd10);
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
        input [7:0] expected_average;
        begin
            if (expected_average === (expected_average ^ average ^ expected_average)) begin
                $display("PASS");
                $display("  Outputs: average=%h",
                         average);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: average=%h",
                         expected_average);
                $display("  Got:      average=%h",
                         average);
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
        $dumpvars(0,clk, d, average);
    end

endmodule
