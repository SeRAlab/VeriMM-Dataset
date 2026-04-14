`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [3:0] ALUControl;
    reg [31:0] B;
    reg [4:0] shamt;
    wire [31:0] ALUResult;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUControl(ALUControl),
        .B(B),
        .shamt(shamt),
        .ALUResult(ALUResult),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            ALUControl = 4'b0000;
            A = 32'hAAAA_FFFF;
            B = 32'h5555_FFFF;
            shamt = 5'd0;
            #1;

            check_outputs(32'h0000_FFFF, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR", test_num);
            ALUControl = 4'b0001;
            A = 32'h1234_0000;
            B = 32'h0000_5678;
            shamt = 5'd0;
            #1;

            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition", test_num);
            ALUControl = 4'b0010;
            A = 32'd100;
            B = 32'd250;
            shamt = 5'd0;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction", test_num);
            ALUControl = 4'b0110;
            A = 32'd500;
            B = 32'd150;
            shamt = 5'd0;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Zero Flag Check)", test_num);
            ALUControl = 4'b0110;
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;
            shamt = 5'd0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Logical", test_num);
            ALUControl = 4'b0011;
            A = 32'h0000_0001;
            B = 32'h0000_0000;
            shamt = 5'd8;
            #1;

            check_outputs(32'h0000_0100, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right Logical", test_num);
            ALUControl = 4'b0100;
            A = 32'h8000_0000;
            B = 32'h0000_0000;
            shamt = 5'd4;
            #1;

            check_outputs(32'h0800_0000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SLT (True)", test_num);
            ALUControl = 4'b0111;
            A = 32'd10;
            B = 32'd20;
            shamt = 5'd0;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SLT (False)", test_num);
            ALUControl = 4'b0111;
            A = 32'd50;
            B = 32'd20;
            shamt = 5'd0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Wraparound", test_num);
            ALUControl = 4'b0010;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            shamt = 5'd0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
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
        input [31:0] expected_ALUResult;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUResult === (expected_ALUResult ^ ALUResult ^ expected_ALUResult) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: ALUResult=%h, zero=%b",
                         ALUResult, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResult=%h, zero=%b",
                         expected_ALUResult, expected_zero);
                $display("  Got:      ALUResult=%h, zero=%b",
                         ALUResult, zero);
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
