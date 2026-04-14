`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] datain;
    reg rst_n;
    wire [31:0] dataout;
    wire signout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .rst_n(rst_n),
        .dataout(dataout),
        .signout(signout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            datain = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Input (0x0000000A)", test_num);
            reset_dut();
            datain = 32'h0000000A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000000A, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Input (0xFFFFFFF6 = -10)", test_num);
            reset_dut();
            datain = 32'hFFFFFFF6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000000A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Input", test_num);
            reset_dut();
            datain = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Negative -1 (0xFFFFFFFF)", test_num);
            reset_dut();
            datain = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Positive (0x7FFFFFFF)", test_num);
            reset_dut();
            datain = 32'h7FFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h7FFFFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Min Negative (0x80000000)", test_num);
            reset_dut();
            datain = 32'h80000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h80000000, 1'b1);
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
        input [31:0] expected_dataout;
        input expected_signout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_signout === (expected_signout ^ signout ^ expected_signout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h, signout=%b",
                         dataout, signout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h, signout=%b",
                         expected_dataout, expected_signout);
                $display("  Got:      dataout=%h, signout=%b",
                         dataout, signout);
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
        $dumpvars(0,clk, datain, rst_n, dataout, signout);
    end

endmodule
