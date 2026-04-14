`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a0;
    reg [63:0] a1;
    reg [63:0] a2;
    reg [2:0] select;
    wire [63:0] a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .select(select),
        .a(a)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select a0 (select = 3'b001)", test_num);
            a0 = 64'hFEDCBA9876543210;
            a1 = 64'h0;
            a2 = 64'h0;
            select = 3'b001;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select a1 (select = 3'b010)", test_num);
            a0 = 64'h0;
            a1 = 64'h123456789ABCDEF0;
            a2 = 64'h0;
            select = 3'b010;
            #1;

            check_outputs(64'h123456789ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select a2 (select = 3'b100)", test_num);
            a0 = 64'h0;
            a1 = 64'h0;
            a2 = 64'hFFFFFFFFFFFFFFFF;
            select = 3'b100;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Invalid select (3'b000) - Default to zero", test_num);
            a0 = 64'hAAAA_AAAA_AAAA_AAAA;
            a1 = 64'hBBBB_BBBB_BBBB_BBBB;
            a2 = 64'hCCCC_CCCC_CCCC_CCCC;
            select = 3'b000;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Invalid select (3'b011) - Default to zero", test_num);
            a0 = 64'h1;
            a1 = 64'h2;
            a2 = 64'h3;
            select = 3'b011;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Invalid select (3'b111) - Default to zero", test_num);
            a0 = 64'hFFFF_0000_FFFF_0000;
            a1 = 64'h0000_FFFF_0000_FFFF;
            a2 = 64'h5555_AAAA_5555_AAAA;
            select = 3'b111;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select a1 with all inputs active", test_num);
            a0 = 64'h1111_1111_1111_1111;
            a1 = 64'h2222_2222_2222_2222;
            a2 = 64'h4444_4444_4444_4444;
            select = 3'b010;
            #1;

            check_outputs(64'h2222_2222_2222_2222);
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
        input [63:0] expected_a;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a)) begin
                $display("PASS");
                $display("  Outputs: a=%h",
                         a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h",
                         expected_a);
                $display("  Got:      a=%h",
                         a);
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
