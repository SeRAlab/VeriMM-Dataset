`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg i;
    reg r;
    reg u;
    wire m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .i(i),
        .r(r),
        .u(u),
        .m(m)
    );
    task testcase001;

    begin
        $display("Test Case 001: arui = 0000");
        test_num = 1;
        {a, r, u, i} = 4'b0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: arui = 0001");
        test_num = 2;
        {a, r, u, i} = 4'b0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: arui = 0010");
        test_num = 3;
        {a, r, u, i} = 4'b0010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: arui = 0011");
        test_num = 4;
        {a, r, u, i} = 4'b0011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: arui = 0100");
        test_num = 5;
        {a, r, u, i} = 4'b0100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: arui = 0101");
        test_num = 6;
        {a, r, u, i} = 4'b0101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: arui = 0110");
        test_num = 7;
        {a, r, u, i} = 4'b0110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: arui = 0111");
        test_num = 8;
        {a, r, u, i} = 4'b0111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: arui = 1000");
        test_num = 9;
        {a, r, u, i} = 4'b1000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: arui = 1001");
        test_num = 10;
        {a, r, u, i} = 4'b1001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: arui = 1010");
        test_num = 11;
        {a, r, u, i} = 4'b1010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: arui = 1011");
        test_num = 12;
        {a, r, u, i} = 4'b1011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        $display("Test Case 013: arui = 1100");
        test_num = 13;
        {a, r, u, i} = 4'b1100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        $display("Test Case 014: arui = 1101");
        test_num = 14;
        {a, r, u, i} = 4'b1101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase015;

    begin
        $display("Test Case 015: arui = 1110");
        test_num = 15;
        {a, r, u, i} = 4'b1110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase016;

    begin
        $display("Test Case 016: arui = 1111");
        test_num = 16;
        {a, r, u, i} = 4'b1111;
        #1;

        check_outputs(1'b0);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: m=%b",
                         m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%b",
                         expected_m);
                $display("  Got:      m=%b",
                         m);
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
