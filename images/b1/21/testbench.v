`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] DMout5;
    reg RegDin5;
    reg [31:0] aluR5;
    reg jal5;
    reg [31:0] pc4_5;
    wire [31:0] RegW_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DMout5(DMout5),
        .RegDin5(RegDin5),
        .aluR5(aluR5),
        .jal5(jal5),
        .pc4_5(pc4_5),
        .RegW_out(RegW_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select pc4_5 (jal5=1, RegDin5=0)", test_num);
            aluR5  = 32'h1111_1111;
            DMout5 = 32'h2222_2222;
            pc4_5  = 32'h3333_3333;
            jal5   = 1'b1;
            RegDin5 = 1'b0;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check (jal5=1, RegDin5=1 -> pc4_5)", test_num);
            aluR5  = 32'hAAAA_AAAA;
            DMout5 = 32'hBBBB_BBBB;
            pc4_5  = 32'hCCCC_CCCC;
            jal5   = 1'b1;
            RegDin5 = 1'b1;
            #1;

            check_outputs(32'hCCCC_CCCC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select DMout5 (jal5=0, RegDin5=1)", test_num);
            aluR5  = 32'h5555_5555;
            DMout5 = 32'h6666_6666;
            pc4_5  = 32'h7777_7777;
            jal5   = 1'b0;
            RegDin5 = 1'b1;
            #1;

            check_outputs(32'h6666_6666);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select aluR5 (jal5=0, RegDin5=0)", test_num);
            aluR5  = 32'hDEAD_BEEF;
            DMout5 = 32'hFEED_FACE;
            pc4_5  = 32'hCAFE_BABE;
            jal5   = 1'b0;
            RegDin5 = 1'b0;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random values, pc4_5 selected", test_num);
            aluR5  = 32'h0F0F_0F0F;
            DMout5 = 32'hF0F0_F0F0;
            pc4_5  = 32'h1234_5678;
            jal5   = 1'b1;
            RegDin5 = 1'b0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random values, DMout5 selected", test_num);
            aluR5  = 32'hA5A5_A5A5;
            DMout5 = 32'h5A5A_5A5A;
            pc4_5  = 32'h0000_FFFF;
            jal5   = 1'b0;
            RegDin5 = 1'b1;
            #1;

            check_outputs(32'h5A5A_5A5A);
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
        input [31:0] expected_RegW_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RegW_out === (expected_RegW_out ^ RegW_out ^ expected_RegW_out)) begin
                $display("PASS");
                $display("  Outputs: RegW_out=%h",
                         RegW_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegW_out=%h",
                         expected_RegW_out);
                $display("  Got:      RegW_out=%h",
                         RegW_out);
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
