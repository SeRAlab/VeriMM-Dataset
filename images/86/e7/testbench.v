`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg expand;
    reg [15:0] imm;
    wire [31:0] expand_imm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .expand(expand),
        .imm(imm),
        .expand_imm(expand_imm)
    );
    task testcase001;

    begin
        test_num = 1;
        expand = 1'b0;
        imm = 16'h1234;
        #5;
        $display("Testcase %0d: Zero-extension, positive value", test_num);
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        expand = 1'b0;
        imm = 16'h8000;
        #5;
        $display("Testcase %0d: Zero-extension, MSB is 1 (should stay zero-extended)", test_num);
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        expand = 1'b1;
        imm = 16'h0ABC;
        #5;
        $display("Testcase %0d: Sign-extension, positive value (MSB=0)", test_num);
        #1;

        check_outputs(32'h00000ABC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        expand = 1'b1;
        imm = 16'hF000;
        #5;
        $display("Testcase %0d: Sign-extension, negative value (MSB=1)", test_num);
        #1;

        check_outputs(32'hFFFFF000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        expand = 1'b1;
        imm = 16'h8000;
        #5;
        $display("Testcase %0d: Sign-extension, edge case MSB=1", test_num);
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        expand = 1'b0;
        imm = 16'hFFFF;
        #5;
        $display("Testcase %0d: Zero-extension, all ones", test_num);
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        expand = 1'b1;
        imm = 16'hFFFF;
        #5;
        $display("Testcase %0d: Sign-extension, all ones", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        expand = 1'b1;
        imm = 16'h0000;
        #5;
        $display("Testcase %0d: Sign-extension, zero", test_num);
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
        input [31:0] expected_expand_imm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_expand_imm === (expected_expand_imm ^ expand_imm ^ expected_expand_imm)) begin
                $display("PASS");
                $display("  Outputs: expand_imm=%h",
                         expand_imm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: expand_imm=%h",
                         expected_expand_imm);
                $display("  Got:      expand_imm=%h",
                         expand_imm);
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
