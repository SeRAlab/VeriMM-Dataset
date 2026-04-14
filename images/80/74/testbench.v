`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] EXTop;
    reg [15:0] imm16;
    wire [31:0] extout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXTop(EXTop),
        .imm16(imm16),
        .extout(extout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            EXTop = 2'b00;
            imm16 = 16'hFFFF;
            $display("Test Case %0d: EXTop=00 (Append Zeros), imm16=0xFFFF", test_num);
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            EXTop = 2'b00;
            imm16 = 16'h1234;
            $display("Test Case %0d: EXTop=00 (Append Zeros), imm16=0x1234", test_num);
            #1;

            check_outputs(32'h12340000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            EXTop = 2'b01;
            imm16 = 16'hFFFF;
            $display("Test Case %0d: EXTop=01 (Zero Extend), imm16=0xFFFF", test_num);
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            EXTop = 2'b01;
            imm16 = 16'hABCD;
            $display("Test Case %0d: EXTop=01 (Zero Extend), imm16=0xABCD", test_num);
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            EXTop = 2'b10;
            imm16 = 16'h8001;
            $display("Test Case %0d: EXTop=10 (Sign Extend), imm16=0x8001 (Neg)", test_num);
            #1;

            check_outputs(32'hFFFF8001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            EXTop = 2'b10;
            imm16 = 16'h7FFF;
            $display("Test Case %0d: EXTop=10 (Sign Extend), imm16=0x7FFF (Pos)", test_num);
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            EXTop = 2'b10;
            imm16 = 16'hFFFF;
            $display("Test Case %0d: EXTop=10 (Sign Extend), imm16=0xFFFF (Neg)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            EXTop = 2'b11;
            imm16 = 16'h0000;
            $display("Test Case %0d: EXTop=11 (Fixed Value), imm16=0x0000", test_num);
            #1;

            check_outputs(32'b0001001000110100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            EXTop = 2'b11;
            imm16 = 16'hAAAA;
            $display("Test Case %0d: EXTop=11 (Fixed Value), imm16=0xAAAA", test_num);
            #1;

            check_outputs(32'b0001001000110100);
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
        input [31:0] expected_extout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extout === (expected_extout ^ extout ^ expected_extout)) begin
                $display("PASS");
                $display("  Outputs: extout=%h",
                         extout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extout=%h",
                         expected_extout);
                $display("  Got:      extout=%h",
                         extout);
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
