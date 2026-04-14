`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [32:0] sub_in;
    wire [32:0] sub_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sub_in(sub_in),
        .sub_out(sub_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input", test_num);
            sub_in = 33'h0_0000_0000;

            #1;


            check_outputs(33'h0_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive one", test_num);
            sub_in = 33'h0_0000_0001;

            #1;


            check_outputs(33'h1_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative one", test_num);
            sub_in = 33'h1_FFFF_FFFF;

            #1;


            check_outputs(33'h0_0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum positive value", test_num);
            sub_in = 33'h0_FFFF_FFFF;

            #1;


            check_outputs(33'h1_0000_0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum negative value (Wrap-around case)", test_num);
            sub_in = 33'h1_0000_0000;


            #1;



            check_outputs(33'h1_0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary pattern A", test_num);
            sub_in = 33'h0_AAAA_AAAA;

            #1;


            check_outputs(33'h1_5555_5556);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary pattern B", test_num);
            sub_in = 33'h0_1234_5678;

            #1;


            check_outputs(33'h1_EDCB_A988);
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
        input [32:0] expected_sub_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sub_out === (expected_sub_out ^ sub_out ^ expected_sub_out)) begin
                $display("PASS");
                $display("  Outputs: sub_out=%h",
                         sub_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sub_out=%h",
                         expected_sub_out);
                $display("  Got:      sub_out=%h",
                         sub_out);
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
