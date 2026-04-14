`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg GPIOfffffe00_we;
    reg [2:0] Test;
    reg [31:0] Test_data0;
    reg [31:0] Test_data1;
    reg [31:0] Test_data2;
    reg [31:0] Test_data3;
    reg [31:0] Test_data4;
    reg [31:0] Test_data5;
    reg [31:0] Test_data6;
    reg clk;
    reg [31:0] disp_cpudata;
    reg rst;
    wire [31:0] disp_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GPIOfffffe00_we(GPIOfffffe00_we),
        .Test(Test),
        .Test_data0(Test_data0),
        .Test_data1(Test_data1),
        .Test_data2(Test_data2),
        .Test_data3(Test_data3),
        .Test_data4(Test_data4),
        .Test_data5(Test_data5),
        .Test_data6(Test_data6),
        .clk(clk),
        .disp_cpudata(disp_cpudata),
        .rst(rst),
        .disp_num(disp_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        GPIOfffffe00_we = 0;
        Test = 0;
        disp_cpudata = 32'h0;
        Test_data0 = 32'h00000001;
        Test_data1 = 32'h00000002;
        Test_data2 = 32'h00000004;
        Test_data3 = 32'h00000008;
        Test_data4 = 32'h00000010;
        Test_data5 = 32'h00000020;
        Test_data6 = 32'h00000040;
        #15;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Selecting Test_data0", test_num);
        reset_dut();
        Test = 3'b001;
        #10;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Writing CPU Data and selecting (Test=0)", test_num);
        reset_dut();
        @(posedge clk);
        GPIOfffffe00_we = 1;
        disp_cpudata = 32'hABCDEF01;
        Test = 3'b000;
        @(posedge clk);
        GPIOfffffe00_we = 0;
        #10;
        #1;

        check_outputs(32'hABCDEF01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Selecting Test_data3", test_num);
        reset_dut();
        Test = 3'b100;
        #10;
        #1;

        check_outputs(32'h00000008);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Selecting Test_data6", test_num);
        reset_dut();
        Test = 3'b111;
        #10;
        #1;

        check_outputs(32'h00000040);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Verify Write Enable (WE=0 shouldn't update)", test_num);
        reset_dut();

        @(posedge clk);
        GPIOfffffe00_we = 1;
        disp_cpudata = 32'h11223344;
        @(posedge clk);

        GPIOfffffe00_we = 0;
        disp_cpudata = 32'hFFFFFFFF;
        @(posedge clk);
        Test = 3'b000;
        #10;
        #1;

        check_outputs(32'h11223344);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Dynamic update of Test_data inputs", test_num);
        reset_dut();
        Test = 3'b010;
        #5;
        Test_data1 = 32'hCAFEBABE;
        #10;
        #1;

        check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_disp_num;
        begin
            if (expected_disp_num === (expected_disp_num ^ disp_num ^ expected_disp_num)) begin
                $display("PASS");
                $display("  Outputs: disp_num=%h",
                         disp_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: disp_num=%h",
                         expected_disp_num);
                $display("  Got:      disp_num=%h",
                         disp_num);
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
        $dumpvars(0,GPIOfffffe00_we, Test, Test_data0, Test_data1, Test_data2, Test_data3, Test_data4, Test_data5, Test_data6, clk, disp_cpudata, rst, disp_num);
    end

endmodule
