`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_val;
    reg [15:0] max_val;
    reg [15:0] min_val;
    reg rst;
    wire [15:0] out_round;
    wire [15:0] out_sat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_val(in_val),
        .max_val(max_val),
        .min_val(min_val),
        .rst(rst),
        .out_round(out_round),
        .out_sat(out_sat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_val = 0;
            min_val = 0;
            max_val = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            in_val = 16'h1234;
            min_val = 16'h0000;
            max_val = 16'hFFFF;

            $display("Test %0d: Reset", test_num);
            #1;

            check_outputs(16'sd0, 16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in_val = 16'sd100;
            min_val = -16'sd500;
            max_val = 16'sd500;
            @(posedge clk);
            #1;
            $display("Test %0d: Round Even (LSB=0), In-Range Sat", test_num);
            #1;

            check_outputs(16'sd100, 16'sd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in_val = 16'sd101;
            min_val = -16'sd500;
            max_val = 16'sd500;
            @(posedge clk);
            #1;
            $display("Test %0d: Round Odd (LSB=1), In-Range Sat", test_num);
            #1;

            check_outputs(16'sd102, 16'sd101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in_val = 16'sd1000;
            min_val = 16'sd0;
            max_val = 16'sd500;
            @(posedge clk);
            #1;
            $display("Test %0d: Saturation Upper Bound", test_num);

            #1;


            check_outputs(16'sd1000, 16'sd500);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in_val = -16'sd1000;
            min_val = -16'sd200;
            max_val = 16'sd200;
            @(posedge clk);
            #1;
            $display("Test %0d: Saturation Lower Bound", test_num);

            #1;


            check_outputs(-16'sd1000, -16'sd200);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in_val = -16'sd5;
            min_val = -16'sd10;
            max_val = 16'sd10;
            @(posedge clk);
            #1;
            $display("Test %0d: Negative Odd Rounding", test_num);

            #1;


            check_outputs(-16'sd4, -16'sd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in_val = 16'sh7FFF;
            min_val = -16'sh8000;
            max_val = 16'sh7FFF;
            @(posedge clk);
            #1;
            $display("Test %0d: Max Signed Value (Overflow Round)", test_num);

            #1;


            check_outputs(-16'sh8000, 16'sh7FFF);
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
        input [15:0] expected_out_round;
        input [15:0] expected_out_sat;
        begin
            if (expected_out_round === (expected_out_round ^ out_round ^ expected_out_round) &&
                expected_out_sat === (expected_out_sat ^ out_sat ^ expected_out_sat)) begin
                $display("PASS");
                $display("  Outputs: out_round=%h, out_sat=%h",
                         out_round, out_sat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_round=%h, out_sat=%h",
                         expected_out_round, expected_out_sat);
                $display("  Got:      out_round=%h, out_sat=%h",
                         out_round, out_sat);
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
        $dumpvars(0,clk, in_val, max_val, min_val, rst, out_round, out_sat);
    end

endmodule
