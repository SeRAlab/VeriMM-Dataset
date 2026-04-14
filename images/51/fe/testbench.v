`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire HS;
    wire VS;
    wire [10:0] countX;
    wire [9:0] countY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .HS(HS),
        .VS(VS),
        .countX(countX),
        .countY(countY)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state after reset");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b1, 11'd0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: HS state at countX=1047");
            reset_dut();
            repeat(1047) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 11'd1047, 10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: HS state at countX=1048 (Transition triggered at 1047)");
            reset_dut();
            repeat(1048) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 11'd1048, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: HS state at countX=1143 (Last pulse count)");
            reset_dut();
            repeat(1143) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 11'd1143, 10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: HS state at countX=1144 (Transition triggered at 1143)");
            reset_dut();
            repeat(1144) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 11'd1144, 10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Horizontal rollover (Y increments to 1)");
            reset_dut();
            repeat(1344) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 11'd0, 10'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: VS state at countY=771 (Transition triggered at countY=770)");
            reset_dut();

            repeat(771 * 1344) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 11'd0, 10'd771);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Full display cycle rollover (X=0, Y=0)");
            reset_dut();

            repeat(806 * 1344) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 11'd0, 10'd0);
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
        input expected_HS;
        input expected_VS;
        input [10:0] expected_countX;
        input [9:0] expected_countY;
        begin
            if (expected_HS === (expected_HS ^ HS ^ expected_HS) &&
                expected_VS === (expected_VS ^ VS ^ expected_VS) &&
                expected_countX === (expected_countX ^ countX ^ expected_countX) &&
                expected_countY === (expected_countY ^ countY ^ expected_countY)) begin
                $display("PASS");
                $display("  Outputs: HS=%b, VS=%b, countX=%h, countY=%h",
                         HS, VS, countX, countY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HS=%b, VS=%b, countX=%h, countY=%h",
                         expected_HS, expected_VS, expected_countX, expected_countY);
                $display("  Got:      HS=%b, VS=%b, countX=%h, countY=%h",
                         HS, VS, countX, countY);
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
        $dumpvars(0,clk, rst, HS, VS, countX, countY);
    end

endmodule
