`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ER_CDE;
    reg clk;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire HEX1DP;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ER_CDE(ER_CDE),
        .clk(clk),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX1DP(HEX1DP),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ER_CDE = 8'b00000000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ER_CDE = 8'b00000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'h00, 7'h00, 1'b0, 7'h00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ER_CDE = 8'b00000001;
            @(posedge clk);
            #1;


            #1;



            check_outputs(HEX0, HEX1, 1'b1, HEX2, HEX3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ER_CDE = 8'b00000010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(HEX0, HEX1, 1'b1, HEX2, HEX3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ER_CDE = 8'b00000011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(HEX0, HEX1, 1'b1, HEX2, HEX3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ER_CDE = 8'b00000100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(HEX0, HEX1, 1'b1, HEX2, HEX3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ER_CDE = 8'b00000101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(HEX0, HEX1, 1'b1, HEX2, HEX3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ER_CDE = 8'b00000110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(HEX0, HEX1, 1'b1, HEX2, HEX3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            ER_CDE = 8'b00000110;
            @(posedge clk);
            #1;

            ER_CDE = 8'b00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h00, 7'h00, 1'b0, 7'h00, 7'h00);
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
        input [6:0] expected_HEX0;
        input [6:0] expected_HEX1;
        input expected_HEX1DP;
        input [6:0] expected_HEX2;
        input [6:0] expected_HEX3;
        begin
            if (expected_HEX0 === (expected_HEX0 ^ HEX0 ^ expected_HEX0) &&
                expected_HEX1 === (expected_HEX1 ^ HEX1 ^ expected_HEX1) &&
                expected_HEX1DP === (expected_HEX1DP ^ HEX1DP ^ expected_HEX1DP) &&
                expected_HEX2 === (expected_HEX2 ^ HEX2 ^ expected_HEX2) &&
                expected_HEX3 === (expected_HEX3 ^ HEX3 ^ expected_HEX3)) begin
                $display("PASS");
                $display("  Outputs: HEX0=%h, HEX1=%h, HEX1DP=%b, HEX2=%h, HEX3=%h",
                         HEX0, HEX1, HEX1DP, HEX2, HEX3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX0=%h, HEX1=%h, HEX1DP=%b, HEX2=%h, HEX3=%h",
                         expected_HEX0, expected_HEX1, expected_HEX1DP, expected_HEX2, expected_HEX3);
                $display("  Got:      HEX0=%h, HEX1=%h, HEX1DP=%b, HEX2=%h, HEX3=%h",
                         HEX0, HEX1, HEX1DP, HEX2, HEX3);
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
        $dumpvars(0,ER_CDE, clk, HEX0, HEX1, HEX1DP, HEX2, HEX3);
    end

endmodule
