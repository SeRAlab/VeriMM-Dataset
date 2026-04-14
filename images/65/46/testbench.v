`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUCtrl_i;
    reg [31:0] data1_i;
    reg [31:0] data2_i;
    wire Zero_o;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUCtrl_i(ALUCtrl_i),
        .data1_i(data1_i),
        .data2_i(data2_i),
        .Zero_o(Zero_o),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition - Simple (10 + 20)", test_num);
        ALUCtrl_i = 3'b000;
        data1_i = 32'd10;
        data2_i = 32'd20;
        #1;

        check_outputs(1'b0, 32'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition - Result Zero (0 + 0)", test_num);
        ALUCtrl_i = 3'b000;
        data1_i = 32'd0;
        data2_i = 32'd0;
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Addition - Overflow/Wrap (0xFFFFFFFF + 1)", test_num);
        ALUCtrl_i = 3'b000;
        data1_i = 32'hFFFFFFFF;
        data2_i = 32'h00000001;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction - Simple (50 - 20)", test_num);
        ALUCtrl_i = 3'b001;
        data1_i = 32'd50;
        data2_i = 32'd20;
        #1;

        check_outputs(1'b0, 32'd30);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Subtraction - Result Zero (15 - 15)", test_num);
        ALUCtrl_i = 3'b001;
        data1_i = 32'd15;
        data2_i = 32'd15;
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction - Negative Result (5 - 10)", test_num);
        ALUCtrl_i = 3'b001;
        data1_i = 32'd5;
        data2_i = 32'd10;
        #1;

        check_outputs(1'b0, 32'hFFFFFFF6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise AND (0xF0F0F0F0 & 0xAAAAAA AA)", test_num);
        ALUCtrl_i = 3'b010;
        data1_i = 32'hF0F0F0F0;
        data2_i = 32'hAAAAAAAA;
        #1;

        check_outputs(1'b0, 32'hA0A0A0A0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bitwise AND - Result Zero", test_num);
        ALUCtrl_i = 3'b010;
        data1_i = 32'hF0F0F0F0;
        data2_i = 32'h0F0F0F0F;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Bitwise OR (0x12340000 | 0x00005678)", test_num);
        ALUCtrl_i = 3'b011;
        data1_i = 32'h12340000;
        data2_i = 32'h00005678;
        #1;

        check_outputs(1'b0, 32'h12345678);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Bitwise OR - Result Zero", test_num);
        ALUCtrl_i = 3'b011;
        data1_i = 32'h00000000;
        data2_i = 32'h00000000;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Multiplication - Simple (12 * 11)", test_num);
        ALUCtrl_i = 3'b100;
        data1_i = 32'd12;
        data2_i = 32'd11;
        #1;

        check_outputs(1'b0, 32'd132);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Multiplication - Result Zero (100 * 0)", test_num);
        ALUCtrl_i = 3'b100;
        data1_i = 32'd100;
        data2_i = 32'd0;
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: Multiplication - 32-bit Truncation", test_num);
        ALUCtrl_i = 3'b100;

        data1_i = 32'h00010000;
        data2_i = 32'h00010000;
        #1;

        check_outputs(1'b1, 32'h00000000);
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
        input expected_Zero_o;
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Zero_o === (expected_Zero_o ^ Zero_o ^ expected_Zero_o) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: Zero_o=%b, data_o=%h",
                         Zero_o, data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Zero_o=%b, data_o=%h",
                         expected_Zero_o, expected_data_o);
                $display("  Got:      Zero_o=%b, data_o=%h",
                         Zero_o, data_o);
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
