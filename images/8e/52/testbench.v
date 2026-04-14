`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0_i;
    reg [31:0] data1_i;
    reg [31:0] data2_i;
    reg [1:0] select_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0_i(data0_i),
        .data1_i(data1_i),
        .data2_i(data2_i),
        .select_i(select_i),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select 00 (data0_i)", test_num);
        data0_i = 32'hDEADBEEF;
        data1_i = 32'h00000000;
        data2_i = 32'hFFFFFFFF;
        select_i = 2'b00;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select 01 (data1_i)", test_num);
        data0_i = 32'h11111111;
        data1_i = 32'h22222222;
        data2_i = 32'h33333333;
        select_i = 2'b01;
        #1;

        check_outputs(32'h22222222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select 10 (data2_i)", test_num);
        data0_i = 32'hAAAA_AAAA;
        data1_i = 32'hBBBB_BBBB;
        data2_i = 32'hCCCC_CCCC;
        select_i = 2'b10;
        #1;

        check_outputs(32'hCCCC_CCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select 11 (Default to data0_i)", test_num);
        data0_i = 32'h12345678;
        data1_i = 32'h87654321;
        data2_i = 32'h55AA55AA;
        select_i = 2'b11;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All Zeros input", test_num);
        data0_i = 32'h0;
        data1_i = 32'h0;
        data2_i = 32'h0;
        select_i = 2'b01;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: All Ones input", test_num);
        data0_i = 32'hFFFFFFFF;
        data1_i = 32'hFFFFFFFF;
        data2_i = 32'hFFFFFFFF;
        select_i = 2'b10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Walking pattern check", test_num);
        data0_i = 32'hF0F0F0F0;
        data1_i = 32'h0F0F0F0F;
        data2_i = 32'hAAAAAAAA;
        select_i = 2'b00;
        #1;

        check_outputs(32'hF0F0F0F0);
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
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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

endmodule
