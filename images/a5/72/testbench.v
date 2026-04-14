`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d0;
    reg [31:0] d1;
    reg [31:0] d2;
    reg [31:0] d3;
    reg s;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .s(s),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select d0 (s=00)", test_num);
        d0 = 32'hAAAA_AAAA;
        d1 = 32'hBBBB_BBBB;
        d2 = 32'hCCCC_CCCC;
        d3 = 32'hDDDD_DDDD;
        s = 2'b00;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select d1 (s=01)", test_num);
        d0 = 32'hAAAA_AAAA;
        d1 = 32'hBBBB_BBBB;
        d2 = 32'hCCCC_CCCC;
        d3 = 32'hDDDD_DDDD;
        s = 2'b01;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select d2 (s=10)", test_num);
        d0 = 32'hAAAA_AAAA;
        d1 = 32'hBBBB_BBBB;
        d2 = 32'hCCCC_CCCC;
        d3 = 32'hDDDD_DDDD;
        s = 2'b10;
        #1;

        check_outputs(32'hCCCC_CCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select d3 (s=11)", test_num);
        d0 = 32'hAAAA_AAAA;
        d1 = 32'hBBBB_BBBB;
        d2 = 32'hCCCC_CCCC;
        d3 = 32'hDDDD_DDDD;
        s = 2'b11;
        #1;

        check_outputs(32'hDDDD_DDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All inputs zero, select d2", test_num);
        d0 = 32'h0;
        d1 = 32'h0;
        d2 = 32'h0;
        d3 = 32'h0;
        s = 2'b10;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Random data pattern, select d1", test_num);
        d0 = 32'h1234_5678;
        d1 = 32'hFEDC_BA98;
        d2 = 32'h00FF_00FF;
        d3 = 32'hFF00_FF00;
        s = 2'b01;
        #1;

        check_outputs(32'hFEDC_BA98);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Unexpected select value (X state)", test_num);
        d0 = 32'h1111_1111;
        d1 = 32'h2222_2222;
        d2 = 32'h3333_3333;
        d3 = 32'h4444_4444;
        s = 2'bxx;
        #1;

        check_outputs(32'h0);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
