`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Valid;
    reg clk;
    reg rst_n;
    wire [3:0] FE_ID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Valid(Valid),
        .clk(clk),
        .rst_n(rst_n),
        .FE_ID(FE_ID)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            Valid = 8'b0;
            #10;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State");
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: No bits set");
            reset_dut();
            Valid = 8'b0000_0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Bit 0 set");
            reset_dut();
            Valid = 8'b0000_0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Bit 3 set");
            reset_dut();
            Valid = 8'b0000_1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multiple bits (LSB at 1)");
            reset_dut();
            Valid = 8'b1010_1010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple bits (LSB at 4)");
            reset_dut();
            Valid = 8'b1111_0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Bit 7 set");
            reset_dut();
            Valid = 8'b1000_0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Asynchronous reset mid-operation");
            reset_dut();
            Valid = 8'b1000_0000;
            @(posedge clk);
            #2;

            rst_n = 0;
            #1;
            #1;

            check_outputs(4'd0);
            rst_n = 1;
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Synchronous capture check");
            reset_dut();
            Valid = 8'b0000_0100;
            @(posedge clk);
            #2;
            Valid = 8'b0000_1000;
            #1;
            #1;

            check_outputs(4'd2);
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
        input [3:0] expected_FE_ID;
        begin
            if (expected_FE_ID === (expected_FE_ID ^ FE_ID ^ expected_FE_ID)) begin
                $display("PASS");
                $display("  Outputs: FE_ID=%h",
                         FE_ID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FE_ID=%h",
                         expected_FE_ID);
                $display("  Got:      FE_ID=%h",
                         FE_ID);
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
        $dumpvars(0,Valid, clk, rst_n, FE_ID);
    end

endmodule
