`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] pos;
    reg rst;
    wire [15:0] value;
    wire [7:0] wavelength;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pos(pos),
        .rst(rst),
        .value(value),
        .wavelength(wavelength)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset and Index 0", test_num);
        rst = 1; pos = 8'd0;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        #1;

        check_outputs(get_expected(0), 8'd44);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset and Index 1", test_num);
        rst = 1; pos = 8'd1;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        #1;

        check_outputs(get_expected(1), 8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset and Index 22", test_num);
        rst = 1; pos = 8'd22;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        #1;

        check_outputs(get_expected(22), 8'd44);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset and Index 43", test_num);
        rst = 1; pos = 8'd43;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        #1;

        check_outputs(get_expected(43), 8'd44);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify wavelength constant at Index 10", test_num);
        rst = 1; pos = 8'd10;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        #1;

        check_outputs(get_expected(10), 8'd44);
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
        input [15:0] expected_value;
        input [7:0] expected_wavelength;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_value === (expected_value ^ value ^ expected_value) &&
                expected_wavelength === (expected_wavelength ^ wavelength ^ expected_wavelength)) begin
                $display("PASS");
                $display("  Outputs: value=%h, wavelength=%h",
                         value, wavelength);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h, wavelength=%h",
                         expected_value, expected_wavelength);
                $display("  Got:      value=%h, wavelength=%h",
                         value, wavelength);
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
