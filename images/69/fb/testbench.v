`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    wire [7:0] byte0;
    wire [7:0] byte1;
    wire [7:0] byte2;
    wire [7:0] byte3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .byte0(byte0),
        .byte1(byte1),
        .byte2(byte2),
        .byte3(byte3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All Zeros", test_num);
        data = 32'h00000000;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All Ones", test_num);
        data = 32'hFFFFFFFF;
        #1;

        check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Sequential Values", test_num);
        data = 32'h11223344;

        #1;


        check_outputs(8'h44, 8'h33, 8'h22, 8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Hex Pattern DEADBEEF", test_num);
        data = 32'hDEADBEEF;
        #1;

        check_outputs(8'hEF, 8'hBE, 8'hAD, 8'hDE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Alternating Bits A", test_num);
        data = 32'hAAAAAAAA;
        #1;

        check_outputs(8'hAA, 8'hAA, 8'hAA, 8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Alternating Bits 5", test_num);
        data = 32'h55555555;
        #1;

        check_outputs(8'h55, 8'h55, 8'h55, 8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Mixed High-Low Bytes", test_num);
        data = 32'hFF00AA55;
        #1;

        check_outputs(8'h55, 8'hAA, 8'h00, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Walking One Pattern", test_num);
        data = 32'h01020408;
        #1;

        check_outputs(8'h08, 8'h04, 8'h02, 8'h01);
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
        input [7:0] expected_byte0;
        input [7:0] expected_byte1;
        input [7:0] expected_byte2;
        input [7:0] expected_byte3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_byte0 === (expected_byte0 ^ byte0 ^ expected_byte0) &&
                expected_byte1 === (expected_byte1 ^ byte1 ^ expected_byte1) &&
                expected_byte2 === (expected_byte2 ^ byte2 ^ expected_byte2) &&
                expected_byte3 === (expected_byte3 ^ byte3 ^ expected_byte3)) begin
                $display("PASS");
                $display("  Outputs: byte0=%h, byte1=%h, byte2=%h, byte3=%h",
                         byte0, byte1, byte2, byte3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: byte0=%h, byte1=%h, byte2=%h, byte3=%h",
                         expected_byte0, expected_byte1, expected_byte2, expected_byte3);
                $display("  Got:      byte0=%h, byte1=%h, byte2=%h, byte3=%h",
                         byte0, byte1, byte2, byte3);
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
