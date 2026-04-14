`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] imm;
    reg [31:0] pc;
    wire [31:0] hik;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .pc(pc),
        .hik(hik)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition", test_num);
            pc = 32'h0000_1000;
            imm = 32'h0000_0004;
            #1;

            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Immediate", test_num);
            pc = 32'h0000_2000;
            imm = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_2000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative (Two's Complement) Immediate", test_num);
            pc = 32'h0000_3000;
            imm = 32'hFFFF_FFF0;
            #1;

            check_outputs(32'h0000_2FF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum PC and Minimum Imm", test_num);
            pc = 32'hFFFF_FFFF;
            imm = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Value Addition", test_num);
            pc = 32'h1234_5678;
            imm = 32'h8765_4321;
            #1;

            check_outputs(32'h9999_9999);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative PC and Positive Imm", test_num);
            pc = 32'hFFFF_0000;
            imm = 32'h0000_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both Maximum Values", test_num);
            pc = 32'hFFFF_FFFF;
            imm = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFE);
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
        input [31:0] expected_hik;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hik === (expected_hik ^ hik ^ expected_hik)) begin
                $display("PASS");
                $display("  Outputs: hik=%h",
                         hik);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hik=%h",
                         expected_hik);
                $display("  Got:      hik=%h",
                         hik);
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
