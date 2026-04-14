`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: AND operation");
        A = 32'hA5A5A5A5;
        B = 32'hFFFF0000;
        opcode = 3'b000;
        #1;

        check_outputs(32'hA5A50000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: OR operation");
        A = 32'h12340000;
        B = 32'h00005678;
        opcode = 3'b001;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: ADD operation (Basic)");
        A = 32'd100;
        B = 32'd250;
        opcode = 3'b010;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: SUBTRACT operation (Positive result)");
        A = 32'd500;
        B = 32'd150;
        opcode = 3'b011;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: LEFT SHIFT operation");
        A = 32'h00000001;
        B = 32'd4;
        opcode = 3'b100;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: RIGHT SHIFT operation");
        A = 32'h000000F0;
        B = 32'd4;
        opcode = 3'b101;
        #1;

        check_outputs(32'h0000000F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: SUBTRACT operation (Underflow/Wrap)");
        A = 32'd10;
        B = 32'd20;
        opcode = 3'b011;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: ADD operation (Overflow/Wrap)");
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        opcode = 3'b010;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: AND operation (All bits)");
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        opcode = 3'b000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: OR operation (All bits)");
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        opcode = 3'b001;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
