`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_select;
    reg [63:0] iv_data1;
    reg [63:0] iv_data2;
    wire [15:0] ov_regstate0;
    wire [15:0] ov_regstate1;
    wire [15:0] ov_regstate2;
    wire [15:0] ov_regstate3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_select(i_select),
        .iv_data1(iv_data1),
        .iv_data2(iv_data2),
        .ov_regstate0(ov_regstate0),
        .ov_regstate1(ov_regstate1),
        .ov_regstate2(ov_regstate2),
        .ov_regstate3(ov_regstate3)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_select = 0;
        iv_data1 = 64'h0;
        iv_data2 = 64'h0;
        @(posedge i_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Select iv_data1", test_num);
        reset_dut();
        i_select = 0;
        iv_data1 = 64'hFEDC_BA98_7654_3210;
        iv_data2 = 64'h0;
        @(posedge i_clk);
        #1;
        #1;

        check_outputs(16'h3210, 16'h7654, 16'hBA98, 16'hFEDC);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Select iv_data2", test_num);
        reset_dut();
        i_select = 1;
        iv_data1 = 64'h0;
        iv_data2 = 64'h0123_4567_89AB_CDEF;
        @(posedge i_clk);
        #1;
        #1;

        check_outputs(16'hCDEF, 16'h89AB, 16'h4567, 16'h0123);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Switching selection", test_num);
        reset_dut();
        iv_data1 = 64'hAAAA_AAAA_AAAA_AAAA;
        iv_data2 = 64'h5555_5555_5555_5555;


        i_select = 0;
        @(posedge i_clk);


        #1 i_select = 1;
        @(posedge i_clk);
        #1;
        #1;

        check_outputs(16'h5555, 16'h5555, 16'h5555, 16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: All Ones Pattern", test_num);
        reset_dut();
        i_select = 0;
        iv_data1 = 64'hFFFF_FFFF_FFFF_FFFF;
        @(posedge i_clk);
        #1;
        #1;

        check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Boundary Bit Test", test_num);
        reset_dut();
        i_select = 1;
        iv_data2 = 64'h8000_0000_0000_0001;
        @(posedge i_clk);
        #1;
        #1;

        check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h8000);
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
        input [15:0] expected_ov_regstate0;
        input [15:0] expected_ov_regstate1;
        input [15:0] expected_ov_regstate2;
        input [15:0] expected_ov_regstate3;
        begin
            if (expected_ov_regstate0 === (expected_ov_regstate0 ^ ov_regstate0 ^ expected_ov_regstate0) &&
                expected_ov_regstate1 === (expected_ov_regstate1 ^ ov_regstate1 ^ expected_ov_regstate1) &&
                expected_ov_regstate2 === (expected_ov_regstate2 ^ ov_regstate2 ^ expected_ov_regstate2) &&
                expected_ov_regstate3 === (expected_ov_regstate3 ^ ov_regstate3 ^ expected_ov_regstate3)) begin
                $display("PASS");
                $display("  Outputs: ov_regstate0=%h, ov_regstate1=%h, ov_regstate2=%h, ov_regstate3=%h",
                         ov_regstate0, ov_regstate1, ov_regstate2, ov_regstate3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ov_regstate0=%h, ov_regstate1=%h, ov_regstate2=%h, ov_regstate3=%h",
                         expected_ov_regstate0, expected_ov_regstate1, expected_ov_regstate2, expected_ov_regstate3);
                $display("  Got:      ov_regstate0=%h, ov_regstate1=%h, ov_regstate2=%h, ov_regstate3=%h",
                         ov_regstate0, ov_regstate1, ov_regstate2, ov_regstate3);
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
        $dumpvars(0,i_clk, i_select, iv_data1, iv_data2, ov_regstate0, ov_regstate1, ov_regstate2, ov_regstate3);
    end

endmodule
