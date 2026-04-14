`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] alu_ctl;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .alu_ctl(alu_ctl),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Addition (100 + 250)", test_num);
            alu_ctl = 4'b0010; A = 32'd100; B = 32'd250;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Subtraction (50 - 50 = 0)", test_num);
            alu_ctl = 4'b0110; A = 32'd50; B = 32'd50;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Bitwise AND", test_num);
            alu_ctl = 4'b0000; A = 32'hAAAA_FFFF; B = 32'h5555_FFFF;
            #1;

            check_outputs(32'h0000_FFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Bitwise OR", test_num);
            alu_ctl = 4'b0001; A = 32'hF0F0_0000; B = 32'h0F0F_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: SLT Signed (-5 < 2)", test_num);
            alu_ctl = 4'b0111; A = -32'd5; B = 32'd2;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: SLT Signed (10 < 5)", test_num);
            alu_ctl = 4'b0111; A = 32'd10; B = 32'd5;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Bitwise NOR", test_num);
            alu_ctl = 4'b1100; A = 32'h0000_0000; B = 32'h0000_0000;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Addition (-10 + 5)", test_num);
            alu_ctl = 4'b0010; A = -32'd10; B = 32'd5;
            #1;

            check_outputs(-32'd5, 1'b0);
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
