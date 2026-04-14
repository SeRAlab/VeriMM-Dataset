`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [31:0] in4;
    reg [31:0] in5;
    reg [31:0] in6;
    reg [31:0] in7;
    reg [31:0] in8;
    wire [15:0] out1;
    wire [15:0] out2;
    wire [15:0] out3;
    wire [15:0] out4;
    wire [15:0] out5;
    wire [15:0] out6;
    wire [15:0] out7;
    wire [15:0] out8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5),
        .out6(out6),
        .out7(out7),
        .out8(out8)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All Zeros");
            in1 = 32'h0; in2 = 32'h0; in3 = 32'h0; in4 = 32'h0;
            in5 = 32'h0; in6 = 32'h0; in7 = 32'h0; in8 = 32'h0;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: All Ones");
            in1 = 32'hFFFFFFFF; in2 = 32'hFFFFFFFF; in3 = 32'hFFFFFFFF; in4 = 32'hFFFFFFFF;
            in5 = 32'hFFFFFFFF; in6 = 32'hFFFFFFFF; in7 = 32'hFFFFFFFF; in8 = 32'hFFFFFFFF;

            #1;


            check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Incremental Patterns");
            in1 = 32'h00001111; in2 = 32'h00002222; in3 = 32'h00003333; in4 = 32'h00004444;
            in5 = 32'h00005555; in6 = 32'h00006666; in7 = 32'h00007777; in8 = 32'h00008888;
            #1;

            check_outputs(16'h1111, 16'h2222, 16'h3333, 16'h4444, 16'h5555, 16'h6666, 16'h7777, 16'h8888);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: High-order bits variation");
            in1 = 32'hAAAA5555; in2 = 32'h5555AAAA; in3 = 32'h1234ABCD; in4 = 32'hFEDC4321;
            in5 = 32'h88887777; in6 = 32'h11110000; in7 = 32'hFFFFEEEE; in8 = 32'h0000CCCC;
            #1;

            check_outputs(16'h5555, 16'hAAAA, 16'hABCD, 16'h4321, 16'h7777, 16'h0000, 16'hEEEE, 16'hCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Alternating Bit Patterns");
            in1 = 32'hAAAAAAAA; in2 = 32'h55555555; in3 = 32'hAAAAAAAA; in4 = 32'h55555555;
            in5 = 32'hAAAAAAAA; in6 = 32'h55555555; in7 = 32'hAAAAAAAA; in8 = 32'h55555555;
            #1;

            check_outputs(16'hAAAA, 16'h5555, 16'hAAAA, 16'h5555, 16'hAAAA, 16'h5555, 16'hAAAA, 16'h5555);
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
        input [15:0] expected_out1;
        input [15:0] expected_out2;
        input [15:0] expected_out3;
        input [15:0] expected_out4;
        input [15:0] expected_out5;
        input [15:0] expected_out6;
        input [15:0] expected_out7;
        input [15:0] expected_out8;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4) &&
                expected_out5 === (expected_out5 ^ out5 ^ expected_out5) &&
                expected_out6 === (expected_out6 ^ out6 ^ expected_out6) &&
                expected_out7 === (expected_out7 ^ out7 ^ expected_out7) &&
                expected_out8 === (expected_out8 ^ out8 ^ expected_out8)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h, out8=%h",
                         out1, out2, out3, out4, out5, out6, out7, out8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h, out8=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4, expected_out5, expected_out6, expected_out7, expected_out8);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h, out8=%h",
                         out1, out2, out3, out4, out5, out6, out7, out8);
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
