`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] data_i;
    reg [31:0] hi_i;
    reg hiw_i;
    reg [31:0] lo_i;
    reg low_i;
    reg [4:0] regw_addr_i;
    reg regw_i;
    reg rst;
    wire [31:0] data_o;
    wire [31:0] hi_o;
    wire hiw_o;
    wire [31:0] lo_o;
    wire low_o;
    wire [4:0] regw_addr_o;
    wire regw_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_i(data_i),
        .hi_i(hi_i),
        .hiw_i(hiw_i),
        .lo_i(lo_i),
        .low_i(low_i),
        .regw_addr_i(regw_addr_i),
        .regw_i(regw_i),
        .rst(rst),
        .data_o(data_o),
        .hi_o(hi_o),
        .hiw_o(hiw_o),
        .lo_o(lo_o),
        .low_o(low_o),
        .regw_addr_o(regw_addr_o),
        .regw_o(regw_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset Behavior", test_num);
        rst = 0;
        data_i = 32'hAAAAAAAA;
        hi_i = 32'hBBBBBBBB;
        lo_i = 32'hCCCCCCCC;
        regw_addr_i = 5'h1F;
        regw_i = 1;
        hiw_i = 1;
        low_i = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 0, 32'h0, 0, 5'h0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Operation Pattern 1", test_num);
        rst = 1;
        data_i = 32'h12345678;
        hi_i = 32'hFEDCBA98;
        lo_i = 32'h76543210;
        regw_addr_i = 5'h0A;
        regw_i = 1;
        hiw_i = 1;
        low_i = 0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h12345678, 32'hFEDCBA98, 1, 32'h76543210, 0, 5'h0A, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Normal Operation Pattern 2", test_num);
        rst = 1;
        data_i = 32'hFFFFFFFF;
        hi_i = 32'h00000000;
        lo_i = 32'h55555555;
        regw_addr_i = 5'h15;
        regw_i = 0;
        hiw_i = 0;
        low_i = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF, 32'h0, 0, 32'h55555555, 1, 5'h15, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Toggling Control Signals", test_num);
        rst = 1;
        data_i = 32'hCAFEBABE;
        hi_i = 32'hDEADBEEF;
        lo_i = 32'h87654321;
        regw_addr_i = 5'h01;
        regw_i = 1;
        hiw_i = 1;
        low_i = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hCAFEBABE, 32'hDEADBEEF, 1, 32'h87654321, 1, 5'h01, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Return to Reset State", test_num);
        rst = 0;
        data_i = 32'h11111111;
        hi_i = 32'h22222222;
        lo_i = 32'h33333333;
        regw_addr_i = 5'h05;
        regw_i = 1;
        hiw_i = 1;
        low_i = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 0, 32'h0, 0, 5'h0, 0);
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
        input [31:0] expected_data_o;
        input [31:0] expected_hi_o;
        input expected_hiw_o;
        input [31:0] expected_lo_o;
        input expected_low_o;
        input [4:0] expected_regw_addr_o;
        input expected_regw_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_hi_o === (expected_hi_o ^ hi_o ^ expected_hi_o) &&
                expected_hiw_o === (expected_hiw_o ^ hiw_o ^ expected_hiw_o) &&
                expected_lo_o === (expected_lo_o ^ lo_o ^ expected_lo_o) &&
                expected_low_o === (expected_low_o ^ low_o ^ expected_low_o) &&
                expected_regw_addr_o === (expected_regw_addr_o ^ regw_addr_o ^ expected_regw_addr_o) &&
                expected_regw_o === (expected_regw_o ^ regw_o ^ expected_regw_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, hi_o=%h, hiw_o=%b, lo_o=%h, low_o=%b, regw_addr_o=%h, regw_o=%b",
                         data_o, hi_o, hiw_o, lo_o, low_o, regw_addr_o, regw_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, hi_o=%h, hiw_o=%b, lo_o=%h, low_o=%b, regw_addr_o=%h, regw_o=%b",
                         expected_data_o, expected_hi_o, expected_hiw_o, expected_lo_o, expected_low_o, expected_regw_addr_o, expected_regw_o);
                $display("  Got:      data_o=%h, hi_o=%h, hiw_o=%b, lo_o=%h, low_o=%b, regw_addr_o=%h, regw_o=%b",
                         data_o, hi_o, hiw_o, lo_o, low_o, regw_addr_o, regw_o);
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
