`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pc;
    wire [31:0] pc1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .pc1(pc1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Increment from Zero", test_num);
        pc = 32'h00000000;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Increment from a standard PC address", test_num);
        pc = 32'h00400000;
        #1;

        check_outputs(32'h00400004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Word-aligned boundary before overflow", test_num);
        pc = 32'hFFFFFFFC;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum 32-bit value overflow", test_num);
        pc = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Middle-range value", test_num);
        pc = 32'h12345678;
        #1;

        check_outputs(32'h1234567C);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating bit pattern", test_num);
        pc = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hAAAAAAAE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Carry propagation across nibbles", test_num);
        pc = 32'h00000FFC;
        #1;

        check_outputs(32'h00001000);
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
        input [31:0] expected_pc1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc1 === (expected_pc1 ^ pc1 ^ expected_pc1)) begin
                $display("PASS");
                $display("  Outputs: pc1=%h",
                         pc1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc1=%h",
                         expected_pc1);
                $display("  Got:      pc1=%h",
                         pc1);
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
