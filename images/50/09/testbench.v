`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg enable;
    reg [63:0] srca;
    reg [63:0] srcb;
    wire [63:0] dst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .srca(srca),
        .srcb(srcb),
        .dst(dst)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: 1.0 * 1.0", test_num);
        enable = 1;
        srca = 64'h3FF0000000000000;
        srcb = 64'h3FF0000000000000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(64'h3FF0000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: 2.0 * 3.0", test_num);
        enable = 1;
        srca = 64'h4000000000000000;
        srcb = 64'h4008000000000000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(64'h4018000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: -2.0 * 4.0", test_num);
        enable = 1;
        srca = 64'hC000000000000000;
        srcb = 64'h4010000000000000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(64'hC020000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: 1.5 * 1.5 (Normalization)", test_num);
        enable = 1;
        srca = 64'h3FF8000000000000;
        srcb = 64'h3FF8000000000000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(64'h4002000000000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: 0.0 * 123.45", test_num);
        enable = 1;
        srca = 64'h0000000000000000;
        srcb = 64'h405EDCCCC0000000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: -0.5 * -4.0", test_num);
        enable = 1;
        srca = 64'hBFE0000000000000;
        srcb = 64'hC010000000000000;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(64'h4000000000000000);
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
        input [63:0] expected_dst;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dst === (expected_dst ^ dst ^ expected_dst)) begin
                $display("PASS");
                $display("  Outputs: dst=%h",
                         dst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dst=%h",
                         expected_dst);
                $display("  Got:      dst=%h",
                         dst);
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
