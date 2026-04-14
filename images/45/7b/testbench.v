`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [1:0] control;
    reg [31:0] d;
    wire [31:0] selected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .control(control),
        .d(d),
        .selected(selected)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input A (control = 00)", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'hBBBB_BBBB;
            c = 32'hCCCC_CCCC;
            d = 32'hDDDD_DDDD;
            control = 2'b00;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input B (control = 01)", test_num);
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            c = 32'h0000_FFFF;
            d = 32'hFFFF_0000;
            control = 2'b01;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input C (control = 10)", test_num);
            a = 32'hDEAD_BEEF;
            b = 32'hCAFE_BABE;
            c = 32'hFACE_FEED;
            d = 32'hBEEF_CAFE;
            control = 2'b10;
            #1;

            check_outputs(32'hFACE_FEED);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input D (control = 11)", test_num);
            a = 32'h0000_0000;
            b = 32'hFFFF_FFFF;
            c = 32'h5555_5555;
            d = 32'hAAAA_AAAA;
            control = 2'b11;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs Zero, Select B", test_num);
            a = 32'h0;
            b = 32'h0;
            c = 32'h0;
            d = 32'h0;
            control = 2'b01;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Switching control with constant data", test_num);
            a = 32'h0000_0001;
            b = 32'h0000_0002;
            c = 32'h0000_0004;
            d = 32'h0000_0008;

            control = 2'b11;
            #1;

            check_outputs(32'h0000_0008);
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
        input [31:0] expected_selected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_selected === (expected_selected ^ selected ^ expected_selected)) begin
                $display("PASS");
                $display("  Outputs: selected=%h",
                         selected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selected=%h",
                         expected_selected);
                $display("  Got:      selected=%h",
                         selected);
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
