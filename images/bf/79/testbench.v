`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [1:0] select;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (00)", test_num);
            in1 = 32'hAAAA_AAAA;
            in2 = 32'hBBBB_BBBB;
            in3 = 32'hCCCC_CCCC;
            select = 2'b00;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (01)", test_num);
            in1 = 32'h1234_5678;
            in2 = 32'h8765_4321;
            in3 = 32'hFFFF_FFFF;
            select = 2'b01;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in3 (10)", test_num);
            in1 = 32'h0000_0000;
            in2 = 32'h5555_5555;
            in3 = 32'hEDCB_A987;
            select = 2'b10;
            #1;

            check_outputs(32'hEDCB_A987);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Constant Zero (11)", test_num);
            in1 = 32'hFFFF_FFFF;
            in2 = 32'hFFFF_FFFF;
            in3 = 32'hFFFF_FFFF;
            select = 2'b11;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values - All inputs zero, select in1", test_num);
            in1 = 32'h0;
            in2 = 32'h0;
            in3 = 32'h0;
            select = 2'b00;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values - All inputs max, select in2", test_num);
            in1 = 32'hFFFF_FFFF;
            in2 = 32'hFFFF_FFFF;
            in3 = 32'hFFFF_FFFF;
            select = 2'b01;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random bit patterns, select in3", test_num);
            in1 = 32'hA5A5_A5A5;
            in2 = 32'h5A5A_5A5A;
            in3 = 32'hDEAD_BEEF;
            select = 2'b10;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify constant zero with different input pattern", test_num);
            in1 = 32'hCAFE_BABE;
            in2 = 32'hBABE_CAFE;
            in3 = 32'h0000_1337;
            select = 2'b11;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
