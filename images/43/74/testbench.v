`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [63:0] data_in;
    reg rst_l;
    reg size_in;
    wire [63:0] data_out;
    wire size_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst_l(rst_l),
        .size_in(size_in),
        .data_out(data_out),
        .size_out(size_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: 64-bit mode pass-through", test_num);
        rst_l = 0; data_in = 0; size_in = 0;
        @(posedge clk);
        #1 rst_l = 1;
        data_in = 64'hFEDCBA9876543210;
        size_in = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(64'hFEDCBA9876543210, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: 4-bit mode truncation and padding", test_num);
        rst_l = 0;
        @(posedge clk);
        #1 rst_l = 1;
        data_in = 64'hAAAA_BBBB_CCCC_DDDD;
        size_in = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(64'h000000000000000D, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: 4-bit mode with all-ones input", test_num);
        rst_l = 0;
        @(posedge clk);
        #1 rst_l = 1;
        data_in = 64'hFFFFFFFFFFFFFFFF;
        size_in = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(64'h000000000000000F, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Mode switching (4-bit to 64-bit)", test_num);
        rst_l = 0;
        @(posedge clk);
        #1 rst_l = 1;

        data_in = 64'h1234567812345678;
        size_in = 1'b1;
        @(posedge clk);

        data_in = 64'h1234567812345678;
        size_in = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(64'h1234567812345678, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Zero input handling in both modes", test_num);
        rst_l = 0;
        @(posedge clk);
        #1 rst_l = 1;
        data_in = 64'h0;
        size_in = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(64'h0, 1'b1);
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
        input [63:0] expected_data_out;
        input expected_size_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_size_out === (expected_size_out ^ size_out ^ expected_size_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, size_out=%b",
                         data_out, size_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, size_out=%b",
                         expected_data_out, expected_size_out);
                $display("  Got:      data_out=%h, size_out=%b",
                         data_out, size_out);
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
