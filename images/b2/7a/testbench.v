`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] s0;
    reg [15:0] s1;
    reg [15:0] s2;
    reg [15:0] s3;
    wire [15:0] d0;
    wire [15:0] d1;
    wire [15:0] d2;
    wire [15:0] d3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3)
    );
    task testcase001;

    begin
        test_num = 1;
        s0 = 16'h0000; s1 = 16'h0000; s2 = 16'h0000; s3 = 16'h0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        s0 = 16'h0001; s1 = 16'h0001; s2 = 16'h0001; s3 = 16'h0001;
        #1;

        check_outputs(16'h0004, 16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        s0 = 16'd10; s1 = 16'd5; s2 = 16'd2; s3 = 16'd1;
        #1;

        check_outputs(16'd18, 16'd12, 16'd6, 16'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        s0 = 16'd1; s1 = 16'd2; s2 = 16'd3; s3 = 16'd4;
        #1;

        check_outputs(16'd10, 16'hFFFC, 16'hFFFE, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        s0 = 16'h0040; s1 = 16'h0020; s2 = 16'h0010; s3 = 16'h0040;
        #1;

        check_outputs(16'd176, 16'd16, 16'hFFF0, 16'd80);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        s0 = 16'd40000; s1 = 16'd30000; s2 = 16'd20000; s3 = 16'd10000;
        #1;

        check_outputs(16'h86A0, 16'h9C40, 16'h4E20, 16'h0000);
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
        input [15:0] expected_d0;
        input [15:0] expected_d1;
        input [15:0] expected_d2;
        input [15:0] expected_d3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1) &&
                expected_d2 === (expected_d2 ^ d2 ^ expected_d2) &&
                expected_d3 === (expected_d3 ^ d3 ^ expected_d3)) begin
                $display("PASS");
                $display("  Outputs: d0=%h, d1=%h, d2=%h, d3=%h",
                         d0, d1, d2, d3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d0=%h, d1=%h, d2=%h, d3=%h",
                         expected_d0, expected_d1, expected_d2, expected_d3);
                $display("  Got:      d0=%h, d1=%h, d2=%h, d3=%h",
                         d0, d1, d2, d3);
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
