`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [3:0] ALUOp;
    reg [31:0] B;
    reg [4:0] s;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUOp(ALUOp),
        .B(B),
        .s(s),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'd15;
            B = 32'd27;
            s = 5'd0;
            ALUOp = 4'd0;
            $display("Test %0d: Addition (15 + 27)", test_num);
            #1;

            check_outputs(32'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'd100;
            B = 32'd35;
            s = 5'd0;
            ALUOp = 4'd1;
            $display("Test %0d: Subtraction (100 - 35)", test_num);
            #1;

            check_outputs(32'd65);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'hF0F0FFFF;
            B = 32'hAAAA5555;
            s = 5'd0;
            ALUOp = 4'd2;
            $display("Test %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'hA0A05555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'hF0F00000;
            B = 32'h0F0FFFFF;
            s = 5'd0;
            ALUOp = 4'd3;
            $display("Test %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'h55555555;
            B = 32'h0;
            s = 5'd0;
            ALUOp = 4'd4;
            $display("Test %0d: Logical Negation (~55555555)", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'h00000001;
            B = 32'h0;
            s = 5'd8;
            ALUOp = 4'd5;
            $display("Test %0d: Shift Left Logical (1 << 8)", test_num);
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'h80000000;
            B = 32'h0;
            s = 5'd4;
            ALUOp = 4'd6;
            $display("Test %0d: Shift Right Logical (0x80.. >> 4)", test_num);
            #1;

            check_outputs(32'h08000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'h80000000;
            B = 32'h0;
            s = 5'd4;
            ALUOp = 4'd7;
            $display("Test %0d: Shift Right Arithmetic (Negative Sign Extension)", test_num);
            #1;

            check_outputs(32'hF8000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 32'd10;
            B = 32'd20;
            s = 5'd0;
            ALUOp = 4'd8;
            $display("Test %0d: Comparison (10 < 20)", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'd50;
            B = 32'd20;
            s = 5'd0;
            ALUOp = 4'd8;
            $display("Test %0d: Comparison (50 < 20)", test_num);
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
