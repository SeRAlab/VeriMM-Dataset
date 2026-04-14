`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] ALU_Sel;
    reg [3:0] B;
    wire [3:0] ALU_Out_EQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALU_Sel(ALU_Sel),
        .B(B),
        .ALU_Out_EQ(ALU_Out_EQ)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0;
        B = 4'd0;
        ALU_Sel = 4'd0;
        $display("Testcase %0d: Testing Equality (Zeros)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd15;
        B = 4'd15;
        ALU_Sel = 4'd0;
        $display("Testcase %0d: Testing Equality (Max Values)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd5;
        B = 4'd5;
        ALU_Sel = 4'd0;
        $display("Testcase %0d: Testing Equality (Mid-range)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd10;
        B = 4'd5;
        ALU_Sel = 4'd0;
        $display("Testcase %0d: Testing Inequality (A > B)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd3;
        B = 4'd12;
        ALU_Sel = 4'd0;
        $display("Testcase %0d: Testing Inequality (A < B)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1010;
        B = 4'b1011;
        ALU_Sel = 4'd0;
        $display("Testcase %0d: Testing Inequality (Single Bit Difference)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd8;
        B = 4'd0;
        ALU_Sel = 4'd0;
        $display("Testcase %0d: Testing Inequality (MSB set vs 0)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd9;
        B = 4'd9;
        ALU_Sel = 4'hf;
        $display("Testcase %0d: Testing Equality with non-zero ALU_Sel", test_num);
        #1;

        check_outputs(4'd1);
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
        input [3:0] expected_ALU_Out_EQ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_Out_EQ === (expected_ALU_Out_EQ ^ ALU_Out_EQ ^ expected_ALU_Out_EQ)) begin
                $display("PASS");
                $display("  Outputs: ALU_Out_EQ=%h",
                         ALU_Out_EQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Out_EQ=%h",
                         expected_ALU_Out_EQ);
                $display("  Got:      ALU_Out_EQ=%h",
                         ALU_Out_EQ);
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
