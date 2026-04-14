`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] a_i;
    reg [23:0] b_i;
    wire [47:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_i(a_i),
        .b_i(b_i),
        .o(o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication (0 * 0)", test_num);
            a_i = 24'h000000;
            b_i = 24'h000000;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiply by zero (Max * 0)", test_num);
            a_i = 24'hFFFFFF;
            b_i = 24'h000000;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity multiplication (1 * 1)", test_num);
            a_i = 24'h000001;
            b_i = 24'h000001;
            #1;

            check_outputs(48'h000000000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity multiplication (Max * 1)", test_num);
            a_i = 24'hFFFFFF;
            b_i = 24'h000001;
            #1;

            check_outputs(48'h000000FFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value multiplication (Max * Max)", test_num);
            a_i = 24'hFFFFFF;
            b_i = 24'hFFFFFF;

            #1;


            check_outputs(48'hFFFFFE000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 multiplication (2^12 * 2^10)", test_num);
            a_i = 24'h001000;
            b_i = 24'h000400;
            #1;

            check_outputs(48'h000000400000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            a_i = 24'hAAAAAA;
            b_i = 24'h555555;

            #1;


            check_outputs(48'h38E38D8E38E2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random arbitrary values 1", test_num);
            a_i = 24'h123456;
            b_i = 24'h789ABC;

            #1;


            check_outputs(48'h89705E19A608);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random arbitrary values 2", test_num);
            a_i = 24'hABCDEF;
            b_i = 24'hFEDCBA;

            #1;


            check_outputs(48'hAB4E59992952);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large value near limit", test_num);
            a_i = 24'h800000;
            b_i = 24'hFFFFFE;

            #1;


            check_outputs(48'h7FFFFF000000);
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
        input [47:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
