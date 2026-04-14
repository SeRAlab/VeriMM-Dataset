`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg cin;
    wire cout;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            cin = 0;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple addition no carry", test_num);
            a = 32'h12345678;
            b = 32'h11111111;
            cin = 0;
            #1;

            check_outputs(1'b0, 32'h23456789);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple addition with carry-in", test_num);
            a = 32'h00000005;
            b = 32'h0000000A;
            cin = 1;
            #1;

            check_outputs(1'b0, 32'h00000010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow to MSB", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            cin = 0;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max addition with carry-in", test_num);
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            cin = 1;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bits", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            cin = 0;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry propagation through all stages", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            cin = 1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High-order byte carry", test_num);
            a = 32'hF0000000;
            b = 32'h10000000;
            cin = 0;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random values test 1", test_num);
            a = 32'h12345678;
            b = 32'h9ABCDEF0;
            cin = 0;
            #1;

            check_outputs(1'b0, 32'hACF13568);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hex constant sum check", test_num);
            a = 32'hDEADBEEF;
            b = 32'hCAFEBABE;
            cin = 0;
            #1;

            check_outputs(1'b1, 32'hA9AC799D);
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
        input expected_cout;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, result=%h",
                         cout, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, result=%h",
                         expected_cout, expected_result);
                $display("  Got:      cout=%b, result=%h",
                         cout, result);
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
