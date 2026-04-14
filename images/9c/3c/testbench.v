`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    reg [5:0] op;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .op(op),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Addition (100 + 250)");
        in1 = 32'd100; in2 = 32'd250; op = 6'h00;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Subtraction (500 - 150)");
        in1 = 32'd500; in2 = 32'd150; op = 6'h01;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Bitwise AND (0xFFFF0000 & 0xAAAA5555)");
        in1 = 32'hFFFF0000; in2 = 32'hAAAA5555; op = 6'h02;
        #1;

        check_outputs(32'hAAAA0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Bitwise OR (0xF0F0F0F0 | 0x0F0F0F0F)");
        in1 = 32'hF0F0F0F0; in2 = 32'h0F0F0F0F; op = 6'h03;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Bitwise XOR (0x12345678 ^ 0x12345678)");
        in1 = 32'h12345678; in2 = 32'h12345678; op = 6'h04;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Shift Left Logical (1 << 8)");
        in1 = 32'h00000001; in2 = 32'd8; op = 6'h05;
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Shift Right Logical (0x80000000 >> 4)");
        in1 = 32'h80000000; in2 = 32'd4; op = 6'h06;
        #1;

        check_outputs(32'h08000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Shift Right Arithmetic (0x80000000 >>> 4)");
        in1 = 32'h80000000; in2 = 32'd4; op = 6'h07;
        #1;

        check_outputs(32'hF8000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Signed Comparison SLT (-1 < 1)");
        in1 = 32'hFFFFFFFF; in2 = 32'h00000001; op = 6'h08;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Unsigned Comparison SLTU (0xFFFFFFFF < 1)");
        in1 = 32'hFFFFFFFF; in2 = 32'h00000001; op = 6'h09;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case 011: Equality Check (42 == 42)");
        in1 = 32'd42; in2 = 32'd42; op = 6'h0A;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case 012: Inequality Check (42 != 43)");
        in1 = 32'd42; in2 = 32'd43; op = 6'h0B;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case 013: Default Operation (Invalid OP)");
        in1 = 32'hFFFFFFFF; in2 = 32'hFFFFFFFF; op = 6'h3F;
        #1;

        check_outputs(32'h00000000);
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
