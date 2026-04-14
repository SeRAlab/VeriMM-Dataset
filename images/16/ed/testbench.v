`timescale 1ns/1ps

module DWT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in_0;
    reg [7:0] data_in_1;
    reg [7:0] data_in_2;
    reg [7:0] data_in_3;
    reg rst;
    wire [7:0] approx_out_0;
    wire [7:0] approx_out_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT dut (
        .clk(clk),
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),
        .rst(rst),
        .approx_out_0(approx_out_0),
        .approx_out_1(approx_out_1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in_0 = 0;
            data_in_1 = 0;
            data_in_2 = 0;
            data_in_3 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive even inputs", test_num);
            reset_dut();
            data_in_0 = 8'sd10;
            data_in_1 = 8'sd20;
            data_in_2 = 8'sd30;
            data_in_3 = 8'sd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd15, 8'sd35);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative inputs", test_num);
            reset_dut();
            data_in_0 = -8'sd10;
            data_in_1 = -8'sd20;
            data_in_2 = -8'sd30;
            data_in_3 = -8'sd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-8'sd15, -8'sd35);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary values", test_num);
            reset_dut();
            data_in_0 = 8'sd127;
            data_in_1 = 8'sd127;
            data_in_2 = -8'sd128;
            data_in_3 = -8'sd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd127, -8'sd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed signs", test_num);
            reset_dut();
            data_in_0 = 8'sd50;
            data_in_1 = -8'sd10;
            data_in_2 = -8'sd100;
            data_in_3 = 8'sd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd20, -8'sd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Odd sums (Rounding)", test_num);
            reset_dut();
            data_in_0 = 8'sd5;
            data_in_1 = 8'sd6;
            data_in_2 = -8'sd5;
            data_in_3 = -8'sd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd5, -8'sd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zeros", test_num);
            reset_dut();
            data_in_0 = 8'sd0;
            data_in_1 = 8'sd0;
            data_in_2 = 8'sd0;
            data_in_3 = 8'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd0, 8'sd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT Testbench");
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
        input [7:0] expected_approx_out_0;
        input [7:0] expected_approx_out_1;
        begin
            if (expected_approx_out_0 === (expected_approx_out_0 ^ approx_out_0 ^ expected_approx_out_0) &&
                expected_approx_out_1 === (expected_approx_out_1 ^ approx_out_1 ^ expected_approx_out_1)) begin
                $display("PASS");
                $display("  Outputs: approx_out_0=%h, approx_out_1=%h",
                         approx_out_0, approx_out_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out_0=%h, approx_out_1=%h",
                         expected_approx_out_0, expected_approx_out_1);
                $display("  Got:      approx_out_0=%h, approx_out_1=%h",
                         approx_out_0, approx_out_1);
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
        $dumpvars(0,clk, data_in_0, data_in_1, data_in_2, data_in_3, rst, approx_out_0, approx_out_1);
    end

endmodule
