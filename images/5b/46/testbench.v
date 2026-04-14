`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] a;
    reg [8:0] b;
    reg [2:0] c;
    reg [2:0] d;
    reg s;
    wire [8:0] o1;
    wire [2:0] o2;
    wire [2:0] o3;
    wire [2:0] o4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .s(s),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: s=0, basic addition/subtraction", test_num);
            s = 0; a = 9'd20; b = 9'd10; c = 3'd0; d = 3'd0;
            #1;

            check_outputs(9'd30, 3'd2, 3'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: s=0, sum overflow and sub truncation", test_num);
            s = 0; a = 9'd511; b = 9'd2; c = 3'd0; d = 3'd0;
            #1;

            check_outputs(9'd1, 3'd5, 3'd0, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: s=0, negative subtraction wrap", test_num);
            s = 0; a = 9'd5; b = 9'd10; c = 3'd0; d = 3'd0;
            #1;

            check_outputs(9'd15, 3'd3, 3'd0, 3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: s=1, conditional mode (a, c, d)", test_num);
            s = 1; a = 9'd25; b = 9'd100; c = 3'd2; d = 3'd3;
            #1;

            check_outputs(9'd0, 3'd1, 3'd5, 3'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: s=1, c+d overflow and zero results", test_num);
            s = 1; a = 9'd511; b = 9'd0; c = 3'd4; d = 3'd4;
            #1;

            check_outputs(9'd0, 3'd7, 3'd0, 3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: s=1, boundary check for a[2:0]", test_num);
            s = 1; a = 9'd8; b = 9'd0; c = 3'd1; d = 3'd1;
            #1;

            check_outputs(9'd0, 3'd0, 3'd2, 3'd0);
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
        input [8:0] expected_o1;
        input [2:0] expected_o2;
        input [2:0] expected_o3;
        input [2:0] expected_o4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4)) begin
                $display("PASS");
                $display("  Outputs: o1=%h, o2=%h, o3=%h, o4=%h",
                         o1, o2, o3, o4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o1=%h, o2=%h, o3=%h, o4=%h",
                         expected_o1, expected_o2, expected_o3, expected_o4);
                $display("  Got:      o1=%h, o2=%h, o3=%h, o4=%h",
                         o1, o2, o3, o4);
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
