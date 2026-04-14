`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALUOp;
    reg [31:0] B;
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
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (15 + 10)", test_num);
            ALUOp = 3'b000; A = 32'd15; B = 32'd10;
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Wrap-around (Max + 1)", test_num);
            ALUOp = 3'b000; A = 32'hFFFFFFFF; B = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (100 - 40)", test_num);
            ALUOp = 3'b001; A = 32'd100; B = 32'd40;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Negative Result (10 - 20)", test_num);
            ALUOp = 3'b001; A = 32'd10; B = 32'd20;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            ALUOp = 3'b010; A = 32'hF0F0AAAA; B = 32'hFFFF0000;
            #1;

            check_outputs(32'hF0F00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            ALUOp = 3'b011; A = 32'h12340000; B = 32'h00005678;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Right Shift (0x80000000 >> 1)", test_num);
            ALUOp = 3'b100; A = 32'h80000000; B = 32'd1;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (0x80000000 >>> 1)", test_num);
            ALUOp = 3'b101; A = 32'h80000000; B = 32'd1;
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift Positive (0x40000000 >>> 2)", test_num);
            ALUOp = 3'b101; A = 32'h40000000; B = 32'd2;
            #1;

            check_outputs(32'h10000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift by zero", test_num);
            ALUOp = 3'b100; A = 32'hABCDE123; B = 32'd0;
            #1;

            check_outputs(32'hABCDE123);
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
