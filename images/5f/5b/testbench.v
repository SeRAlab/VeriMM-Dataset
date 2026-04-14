`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Ex_top;
    reg [15:0] Imm;
    wire [31:0] Immediate32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ex_top(Ex_top),
        .Imm(Imm),
        .Immediate32(Immediate32)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Sign Extension (Positive)", test_num);
            Imm = 16'h7FFF;
            Ex_top = 2'b00;
            #1;

            check_outputs(32'h0000_7FFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Sign Extension (Negative)", test_num);
            Imm = 16'h8000;
            Ex_top = 2'b00;
            #1;

            check_outputs(32'hFFFF_8000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Zero Extension (Positive)", test_num);
            Imm = 16'h7FFF;
            Ex_top = 2'b01;
            #1;

            check_outputs(32'h0000_7FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Zero Extension (Negative-like)", test_num);
            Imm = 16'hFFFF;
            Ex_top = 2'b01;
            #1;

            check_outputs(32'h0000_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Left Shift (Ex_top=10)", test_num);
            Imm = 16'hABCD;
            Ex_top = 2'b10;
            #1;

            check_outputs(32'hABCD_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Left Shift (Ex_top=11)", test_num);
            Imm = 16'h1234;
            Ex_top = 2'b11;
            #1;

            check_outputs(32'h1234_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Sign Extension (All Ones)", test_num);
            Imm = 16'hFFFF;
            Ex_top = 2'b00;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Left Shift (Zero)", test_num);
            Imm = 16'h0000;
            Ex_top = 2'b10;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_Immediate32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Immediate32 === (expected_Immediate32 ^ Immediate32 ^ expected_Immediate32)) begin
                $display("PASS");
                $display("  Outputs: Immediate32=%h",
                         Immediate32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Immediate32=%h",
                         expected_Immediate32);
                $display("  Got:      Immediate32=%h",
                         Immediate32);
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
