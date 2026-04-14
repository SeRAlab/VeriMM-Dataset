`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c0;
    reg c1;
    reg c2;
    reg c3;
    wire [6:0] hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .hex(hex)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0000 (0)", test_num);
        c3 = 0; c2 = 0; c1 = 0; c0 = 0;
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0001 (1)", test_num);
        c3 = 0; c2 = 0; c1 = 0; c0 = 1;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0010 (2)", test_num);
        c3 = 0; c2 = 0; c1 = 1; c0 = 0;
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0011 (3)", test_num);
        c3 = 0; c2 = 0; c1 = 1; c0 = 1;
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0100 (4)", test_num);
        c3 = 0; c2 = 1; c1 = 0; c0 = 0;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0101 (5)", test_num);
        c3 = 0; c2 = 1; c1 = 0; c0 = 1;
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0110 (6)", test_num);
        c3 = 0; c2 = 1; c1 = 1; c0 = 0;
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 0111 (7)", test_num);
        c3 = 0; c2 = 1; c1 = 1; c0 = 1;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1000 (8)", test_num);
        c3 = 1; c2 = 0; c1 = 0; c0 = 0;
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1001 (9)", test_num);
        c3 = 1; c2 = 0; c1 = 0; c0 = 1;
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1010 (A)", test_num);
        c3 = 1; c2 = 0; c1 = 1; c0 = 0;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1011 (B)", test_num);
        c3 = 1; c2 = 0; c1 = 1; c0 = 1;
        #1;

        check_outputs(7'h7c);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1100 (C)", test_num);
        c3 = 1; c2 = 1; c1 = 0; c0 = 0;
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1101 (D)", test_num);
        c3 = 1; c2 = 1; c1 = 0; c0 = 1;
        #1;

        check_outputs(7'h5e);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1110 (E)", test_num);
        c3 = 1; c2 = 1; c1 = 1; c0 = 0;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary 1111 (F)", test_num);
        c3 = 1; c2 = 1; c1 = 1; c0 = 1;
        #1;

        check_outputs(7'h71);
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
        input [6:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
