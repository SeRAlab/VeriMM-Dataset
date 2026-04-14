`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg select;
    wire [27:0] lefto;
    wire [27:0] righto;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .select(select),
        .lefto(lefto),
        .righto(righto)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros, select=0", test_num);
        select = 0;
        key = 64'h0;
        #1;

        check_outputs(28'h0, 28'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones, select=0", test_num);
        select = 0;
        key = 64'hFFFFFFFFFFFFFFFF;

        #1;


        check_outputs(28'hFFFFFFF, 28'hFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros, select=1", test_num);
        select = 1;
        key = 64'h0;
        #1;

        check_outputs(28'h0, 28'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones, select=1", test_num);
        select = 1;
        key = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(28'hFFFFFFF, 28'hFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data Pattern, select=0", test_num);
        select = 0;
        key = 64'hFEDCBA9876543210;

        #1;


        check_outputs(28'hFEDCBA9, 28'h8765432);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: DES PC-1 Permutation, select=1", test_num);
        select = 1;
        key = 64'h133457799BBCDFF1;

        #1;


        check_outputs(28'hF0CCAAF, 28'h5566778);
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
        input [27:0] expected_lefto;
        input [27:0] expected_righto;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lefto === (expected_lefto ^ lefto ^ expected_lefto) &&
                expected_righto === (expected_righto ^ righto ^ expected_righto)) begin
                $display("PASS");
                $display("  Outputs: lefto=%h, righto=%h",
                         lefto, righto);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lefto=%h, righto=%h",
                         expected_lefto, expected_righto);
                $display("  Got:      lefto=%h, righto=%h",
                         lefto, righto);
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
