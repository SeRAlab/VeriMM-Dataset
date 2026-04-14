`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] aluCtr;
    reg [31:0] input1;
    reg [31:0] input2;
    wire [31:0] aluRes;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluCtr(aluCtr),
        .input1(input1),
        .input2(input2),
        .aluRes(aluRes),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            aluCtr = 4'b0010;
            input1 = 32'h0000_0005;
            input2 = 32'h0000_000A;
            $display("Test %0d: Addition (5 + 10)", test_num);
            #1;

            check_outputs(32'h0000_000F, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            aluCtr = 4'b0110;
            input1 = 32'h0000_0014;
            input2 = 32'h0000_0005;
            $display("Test %0d: Subtraction (20 - 5)", test_num);
            #1;

            check_outputs(32'h0000_000F, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            aluCtr = 4'b0110;
            input1 = 32'h0000_00FF;
            input2 = 32'h0000_00FF;
            $display("Test %0d: Subtraction Resulting in Zero", test_num);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            aluCtr = 4'b0000;
            input1 = 32'hF0F0_AAAA;
            input2 = 32'h0F0F_FFFF;
            $display("Test %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'h0000_AAAA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            aluCtr = 4'b0001;
            input1 = 32'hF0F0_0000;
            input2 = 32'h0000_AAAA;
            $display("Test %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hF0F0_AAAA, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            aluCtr = 4'b1100;
            input1 = 32'h0000_FFFF;
            input2 = 32'hFFFF_0000;
            $display("Test %0d: Bitwise NOR", test_num);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            aluCtr = 4'b0111;
            input1 = 32'h0000_0001;
            input2 = 32'h0000_0002;
            $display("Test %0d: SLT (1 < 2)", test_num);
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            aluCtr = 4'b0111;
            input1 = 32'h0000_000A;
            input2 = 32'h0000_0005;
            $display("Test %0d: SLT (10 < 5)", test_num);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            aluCtr = 4'b0111;
            input1 = 32'hFFFF_FFFF;
            input2 = 32'h0000_0001;
            $display("Test %0d: SLT Signed (-1 < 1)", test_num);
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            aluCtr = 4'b0010;
            input1 = 32'hFFFF_FFFF;
            input2 = 32'h0000_0001;
            $display("Test %0d: Addition Overflow (Max + 1)", test_num);
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
        input [31:0] expected_aluRes;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluRes === (expected_aluRes ^ aluRes ^ expected_aluRes) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: aluRes=%h, zero=%b",
                         aluRes, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluRes=%h, zero=%b",
                         expected_aluRes, expected_zero);
                $display("  Got:      aluRes=%h, zero=%b",
                         aluRes, zero);
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
