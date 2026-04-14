`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aluSrc0;
    reg aluSrc1;
    reg [7:0] imm;
    reg [15:0] p0;
    reg [15:0] p1;
    wire [15:0] src0;
    wire [15:0] src1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluSrc0(aluSrc0),
        .aluSrc1(aluSrc1),
        .imm(imm),
        .p0(p0),
        .p1(p1),
        .src0(src0),
        .src1(src1)
    );
    task testcase001;

        begin
            test_num = 1;
            p0 = 16'hABCD;
            p1 = 16'h1234;
            imm = 8'h55;
            aluSrc0 = 0;
            aluSrc1 = 0;
            #1;

            check_outputs(16'hABCD, 16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            p0 = 16'h0000;
            p1 = 16'h7890;
            imm = 8'h42;
            aluSrc0 = 1;
            aluSrc1 = 0;
            #1;

            check_outputs(16'h0042, 16'h7890);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            p0 = 16'hFFFF;
            p1 = 16'h4321;
            imm = 8'h85;
            aluSrc0 = 1;
            aluSrc1 = 0;
            #1;

            check_outputs(16'hFF85, 16'h4321);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            p0 = 16'h1111;
            p1 = 16'h0000;
            imm = 8'h0F;
            aluSrc0 = 0;
            aluSrc1 = 1;
            #1;

            check_outputs(16'h1111, 16'h000F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            p0 = 16'hEEEE;
            p1 = 16'h0000;
            imm = 8'hF0;
            aluSrc0 = 0;
            aluSrc1 = 1;
            #1;

            check_outputs(16'hEEEE, 16'hFFF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            p0 = 16'hAAAA;
            p1 = 16'hBBBB;
            imm = 8'h80;
            aluSrc0 = 1;
            aluSrc1 = 1;
            #1;

            check_outputs(16'hFF80, 16'hFF80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            p0 = 16'h0;
            p1 = 16'h0;
            imm = 8'h7F;
            aluSrc0 = 1;
            aluSrc1 = 1;
            #1;

            check_outputs(16'h007F, 16'h007F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            p0 = 16'h1234;
            p1 = 16'h5678;
            imm = 8'hFF;
            aluSrc0 = 1;
            aluSrc1 = 0;
            #5;
            aluSrc0 = 0;
            aluSrc1 = 1;
            #1;

            check_outputs(16'h1234, 16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            p0 = 16'h0000;
            p1 = 16'h0000;
            imm = 8'hFF;
            aluSrc0 = 1;
            aluSrc1 = 1;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
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
        input [15:0] expected_src0;
        input [15:0] expected_src1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_src0 === (expected_src0 ^ src0 ^ expected_src0) &&
                expected_src1 === (expected_src1 ^ src1 ^ expected_src1)) begin
                $display("PASS");
                $display("  Outputs: src0=%h, src1=%h",
                         src0, src1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: src0=%h, src1=%h",
                         expected_src0, expected_src1);
                $display("  Got:      src0=%h, src1=%h",
                         src0, src1);
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
