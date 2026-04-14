`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [15:0] i_0;
    reg [15:0] i_1;
    reg [15:0] i_2;
    reg [15:0] i_3;
    reg [15:0] i_4;
    reg [15:0] i_5;
    reg [15:0] i_6;
    reg [15:0] i_7;
    reg inverse;
    wire [15:0] o_0;
    wire [15:0] o_1;
    wire [15:0] o_2;
    wire [15:0] o_3;
    wire [15:0] o_4;
    wire [15:0] o_5;
    wire [15:0] o_6;
    wire [15:0] o_7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .i_0(i_0),
        .i_1(i_1),
        .i_2(i_2),
        .i_3(i_3),
        .i_4(i_4),
        .i_5(i_5),
        .i_6(i_6),
        .i_7(i_7),
        .inverse(inverse),
        .o_0(o_0),
        .o_1(o_1),
        .o_2(o_2),
        .o_3(o_3),
        .o_4(o_4),
        .o_5(o_5),
        .o_6(o_6),
        .o_7(o_7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Direct Pass-through (enable=1, inverse=0)", test_num);
            enable = 1'b1;
            inverse = 1'b0;
            i_0 = 16'h0001;
            i_1 = 16'h0002;
            i_2 = 16'h0003;
            i_3 = 16'h0004;
            i_4 = 16'h0005;
            i_5 = 16'h0006;
            i_6 = 16'h0007;
            i_7 = 16'h0008;

            #1;


            check_outputs(16'h0001, 16'h0002, 16'h0003, 16'h0004, 16'h0005, 16'h0006, 16'h0007, 16'h0008);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reordered Pass-through (enable=1, inverse=1)", test_num);
            enable = 1'b1;
            inverse = 1'b1;
            i_0 = 16'h1111;
            i_1 = 16'h0001;
            i_2 = 16'h0002;
            i_3 = 16'h0003;
            i_4 = 16'h0004;
            i_5 = 16'h0005;
            i_6 = 16'h0006;
            i_7 = 16'h8888;

            #1;


            check_outputs(16'h1111, 16'h0006, 16'h0005, 16'h0004, 16'h0003, 16'h0002, 16'h0001, 16'h8888);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Disabled State (enable=0, inverse=0)", test_num);
            enable = 1'b0;
            inverse = 1'b0;
            i_0 = 16'hAAAA;
            i_1 = 16'h0001;
            i_2 = 16'h0002;
            i_3 = 16'h0003;
            i_4 = 16'h0004;
            i_5 = 16'h0005;
            i_6 = 16'h0006;
            i_7 = 16'h5555;

            #1;


            check_outputs(16'hAAAA, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Disabled State with Inverse Bit (enable=0, inverse=1)", test_num);
            enable = 1'b0;
            inverse = 1'b1;
            i_0 = 16'h1234;
            i_1 = 16'hFFFF;
            i_2 = 16'hFFFF;
            i_3 = 16'hFFFF;
            i_4 = 16'hFFFF;
            i_5 = 16'hFFFF;
            i_6 = 16'hFFFF;
            i_7 = 16'h4321;

            #1;


            check_outputs(16'h1234, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h4321);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Signed Boundary Values (enable=1, inverse=1)", test_num);
            enable = 1'b1;
            inverse = 1'b1;
            i_0 = 16'sh8000;
            i_1 = 16'sh7FFF;
            i_2 = 16'sh0000;
            i_3 = 16'shFFFF;
            i_4 = 16'sh0001;
            i_5 = 16'shABCD;
            i_6 = 16'sh1234;
            i_7 = 16'sh7FFF;

            #1;


            check_outputs(16'h8000, 16'h1234, 16'hABCD, 16'h0001, 16'hFFFF, 16'h0000, 16'h7FFF, 16'h7FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Rapid Toggle Check (enable=1, inverse=0)", test_num);
            enable = 1'b1;
            inverse = 1'b0;
            i_0 = 16'hDEAF; i_1 = 16'hBEEF; i_2 = 16'hCAFE; i_3 = 16'hBABE;
            i_4 = 16'hFACE; i_5 = 16'hDEAD; i_6 = 16'hBEEF; i_7 = 16'hFEED;
            #1;

            check_outputs(16'hDEAF, 16'hBEEF, 16'hCAFE, 16'hBABE, 16'hFACE, 16'hDEAD, 16'hBEEF, 16'hFEED);
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
        input [15:0] expected_o_0;
        input [15:0] expected_o_1;
        input [15:0] expected_o_2;
        input [15:0] expected_o_3;
        input [15:0] expected_o_4;
        input [15:0] expected_o_5;
        input [15:0] expected_o_6;
        input [15:0] expected_o_7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_0 === (expected_o_0 ^ o_0 ^ expected_o_0) &&
                expected_o_1 === (expected_o_1 ^ o_1 ^ expected_o_1) &&
                expected_o_2 === (expected_o_2 ^ o_2 ^ expected_o_2) &&
                expected_o_3 === (expected_o_3 ^ o_3 ^ expected_o_3) &&
                expected_o_4 === (expected_o_4 ^ o_4 ^ expected_o_4) &&
                expected_o_5 === (expected_o_5 ^ o_5 ^ expected_o_5) &&
                expected_o_6 === (expected_o_6 ^ o_6 ^ expected_o_6) &&
                expected_o_7 === (expected_o_7 ^ o_7 ^ expected_o_7)) begin
                $display("PASS");
                $display("  Outputs: o_0=%h, o_1=%h, o_2=%h, o_3=%h, o_4=%h, o_5=%h, o_6=%h, o_7=%h",
                         o_0, o_1, o_2, o_3, o_4, o_5, o_6, o_7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_0=%h, o_1=%h, o_2=%h, o_3=%h, o_4=%h, o_5=%h, o_6=%h, o_7=%h",
                         expected_o_0, expected_o_1, expected_o_2, expected_o_3, expected_o_4, expected_o_5, expected_o_6, expected_o_7);
                $display("  Got:      o_0=%h, o_1=%h, o_2=%h, o_3=%h, o_4=%h, o_5=%h, o_6=%h, o_7=%h",
                         o_0, o_1, o_2, o_3, o_4, o_5, o_6, o_7);
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
