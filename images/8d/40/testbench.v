`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] Op;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Op(Op),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (15 + 10)", test_num);
        A = 32'd15;
        B = 32'd10;
        Op = 4'd0;
        #1;

        check_outputs(32'd25);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (Edge case: Maximum values)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'd1;
        Op = 4'd0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (50 - 20)", test_num);
        A = 32'd50;
        B = 32'd20;
        Op = 4'd1;
        #1;

        check_outputs(32'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (Result zero)", test_num);
        A = 32'h12345678;
        B = 32'h12345678;
        Op = 4'd1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise AND", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hAAAA5555;
        Op = 4'd2;
        #1;

        check_outputs(32'hA0A05050);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise OR", test_num);
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        Op = 4'd3;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        Op = 4'd4;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Logical Left Shift (SLL)", test_num);
        A = 32'h00000001;
        B = 32'd8;
        Op = 4'd5;
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Logical Right Shift (SRL)", test_num);
        A = 32'h80000000;
        B = 32'd4;
        Op = 4'd6;
        #1;

        check_outputs(32'h08000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arithmetic Right Shift (SRA)", test_num);
        A = 32'hF0000000;
        B = 32'd4;
        Op = 4'd7;
        #1;

        check_outputs(32'hFF000000);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Comparison (SLT: -5 < 10)", test_num);
        A = -32'd5;
        B = 32'd10;
        Op = 4'd8;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Unsigned Comparison (SLTU: -5 < 10 is false)", test_num);
        A = 32'hFFFFFFF0;
        B = 32'd10;
        Op = 4'd9;
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
        testcase011();
        testcase012();
        
        
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
