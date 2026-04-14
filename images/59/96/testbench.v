`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg select;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .select(select),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select A (basic values)", test_num);
            a = 64'h0123456789ABCDEF;
            b = 64'hFEDCBA9876543210;
            select = 1'b0;
            #1;

            check_outputs(a);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select B (basic values)", test_num);
            a = 64'h0123456789ABCDEF;
            b = 64'hFEDCBA9876543210;
            select = 1'b1;
            #1;

            check_outputs(b);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select A (all ones vs all zeros)", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'h0000000000000000;
            select = 1'b0;
            #1;

            check_outputs(a);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select B (all ones vs all zeros)", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'h0000000000000000;
            select = 1'b1;
            #1;

            check_outputs(b);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select A (alternating bit patterns)", test_num);
            a = 64'hAAAAAAAAAAAAAAAA;
            b = 64'h5555555555555555;
            select = 1'b0;
            #1;

            check_outputs(a);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select B (alternating bit patterns)", test_num);
            a = 64'hAAAAAAAAAAAAAAAA;
            b = 64'h5555555555555555;
            select = 1'b1;
            #1;

            check_outputs(b);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Random selection A", test_num);
            a = 64'hCAFEBABE12345678;
            b = 64'hDEADBEEF87654321;
            select = 1'b0;
            #1;

            check_outputs(64'hCAFEBABE12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Random selection B", test_num);
            a = 64'hCAFEBABE12345678;
            b = 64'hDEADBEEF87654321;
            select = 1'b1;
            #1;

            check_outputs(64'hDEADBEEF87654321);
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
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
