`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg c_in;
    wire [63:0] sumv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .sumv(sumv)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            a = 64'h0;
            b = 64'h0;
            c_in = 0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic small numbers", test_num);
            a = 64'h1234;
            b = 64'h5678;
            c_in = 0;
            #1;

            check_outputs(64'h1234 + 64'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic addition with Carry-In", test_num);
            a = 64'hA;
            b = 64'h5;
            c_in = 1;
            #1;

            check_outputs(64'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max 64-bit value overflow (wrap-around)", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'h1;
            c_in = 0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values and Carry-In", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'h0;
            c_in = 1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range large numbers", test_num);
            a = 64'h5555555555555555;
            b = 64'hAAAAAAAAAAAAAAAA;
            c_in = 0;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range overflow with Carry-In", test_num);
            a = 64'h5555555555555555;
            b = 64'hAAAAAAAAAAAAAAAA;
            c_in = 1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High bit addition", test_num);
            a = 64'h8000000000000000;
            b = 64'h8000000000000000;
            c_in = 0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex bit patterns", test_num);
            a = 64'hFEDCBA9876543210;
            b = 64'h0123456789ABCDEF;
            c_in = 0;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max plus Max plus Carry", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;
            c_in = 1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
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
        input [63:0] expected_sumv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sumv === (expected_sumv ^ sumv ^ expected_sumv)) begin
                $display("PASS");
                $display("  Outputs: sumv=%h",
                         sumv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sumv=%h",
                         expected_sumv);
                $display("  Got:      sumv=%h",
                         sumv);
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
