`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] in;
    wire [10:0] out_and;
    wire [11:0] out_diff_wrap;
    wire [10:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_diff_wrap(out_diff_wrap),
        .out_xor(out_xor)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        in = 12'h000;
        #1;

        check_outputs(11'h000, 12'h000, 11'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones", test_num);
        in = 12'hFFF;
        #1;

        check_outputs(11'h7FF, 12'h000, 11'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating 1010...", test_num);
        in = 12'hAAA;



        #1;




        check_outputs(11'h000, 12'hFFF, 11'h7FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating 0101...", test_num);
        in = 12'h555;
        #1;

        check_outputs(11'h000, 12'hFFF, 11'h7FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Block Pattern F0F", test_num);
        in = 12'hF0F;




        #1;





        check_outputs(11'h707, 12'h110, 11'h088);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sparse bits (801)", test_num);
        in = 12'h801;



        #1;




        check_outputs(11'h000, 12'h802, 11'h401);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Dense bits (7FE)", test_num);
        in = 12'h7FE;



        #1;




        check_outputs(11'h3FE, 12'h802, 11'h401);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern (123)", test_num);
        in = 12'h123;



        #1;




        check_outputs(11'h001, 12'h365, 11'h1B2);
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
        input [10:0] expected_out_and;
        input [11:0] expected_out_diff_wrap;
        input [10:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_diff_wrap === (expected_out_diff_wrap ^ out_diff_wrap ^ expected_out_diff_wrap) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_diff_wrap=%h, out_xor=%h",
                         out_and, out_diff_wrap, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_diff_wrap=%h, out_xor=%h",
                         expected_out_and, expected_out_diff_wrap, expected_out_xor);
                $display("  Got:      out_and=%h, out_diff_wrap=%h, out_xor=%h",
                         out_and, out_diff_wrap, out_xor);
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
