`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] dataa;
    reg [1:0] in_select;
    reg reset;
    wire [511:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataa(dataa),
        .in_select(in_select),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dataa = 0;
            in_select = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        reg [511:0] expected;
        begin
            test_num = 1;
            reset_dut();
            dataa = 256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210;
            in_select = 2'b11;
            expected = calculate_expected(dataa, in_select, 0);
            @(posedge clk);
            #1 #1;
 check_outputs(expected);
        end
        endtask

    task testcase002;

        reg [511:0] expected;
        begin
            test_num = 2;
            reset_dut();

            dataa = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            in_select = 2'b11;
            @(posedge clk);
            #1 expected = result;


            dataa = 256'h0;
            in_select = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [511:0] expected;
        begin
            test_num = 3;
            reset_dut();
            dataa = {256{1'b1}};
            in_select = 2'b11;
            expected = calculate_expected(dataa, in_select, 0);
            @(posedge clk);
            #1 #1;
 check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [511:0] expected;
        begin
            test_num = 4;
            reset_dut();
            dataa = 256'h0001_0002_0004_0008_0010_0020_0040_0080_0100_0200_0400_0800_1000_2000_4000_8000;
            in_select = 2'b11;
            expected = calculate_expected(dataa, in_select, 0);
            @(posedge clk);
            #1 #1;
 check_outputs(expected);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            dataa = {256{1'b1}};
            in_select = 2'b11;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(512'b0);
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
        input [511:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, dataa, in_select, reset, result);
    end

endmodule
