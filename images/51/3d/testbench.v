`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALUCtr;
    reg [31:0] B;
    wire [31:0] ALUOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUCtr(ALUCtr),
        .B(B),
        .ALUOut(ALUOut)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hAAAA5555;
        ALUCtr = 3'b000;
        #1;

        check_outputs(32'hA0A05050);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hAAAA5555;
        ALUCtr = 3'b001;
        #1;

        check_outputs(32'hFAFAF5F5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition", test_num);
        A = 32'd12345678;
        B = 32'd87654321;
        ALUCtr = 3'b010;
        #1;

        check_outputs(32'd99999999);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction", test_num);
        A = 32'd1000;
        B = 32'd400;
        ALUCtr = 3'b011;
        #1;

        check_outputs(32'd600);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (Positive)", test_num);
        A = 32'd4;
        B = 32'h000000F0;
        ALUCtr = 3'b100;
        #1;

        check_outputs(32'h0000000F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (Negative/Sign Extension)", test_num);
        A = 32'd8;
        B = 32'h80000000;
        ALUCtr = 3'b100;
        #1;

        check_outputs(32'hFF800000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift by 0", test_num);
        A = 32'd0;
        B = 32'hDEADBEEF;
        ALUCtr = 3'b100;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Invalid Control Signal (Expect 0)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        ALUCtr = 3'b101;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Negative Result)", test_num);
        A = 32'd10;
        B = 32'd20;
        ALUCtr = 3'b011;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow/Wrap", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALUCtr = 3'b010;
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
        input [31:0] expected_ALUOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOut === (expected_ALUOut ^ ALUOut ^ expected_ALUOut)) begin
                $display("PASS");
                $display("  Outputs: ALUOut=%h",
                         ALUOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOut=%h",
                         expected_ALUOut);
                $display("  Got:      ALUOut=%h",
                         ALUOut);
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
