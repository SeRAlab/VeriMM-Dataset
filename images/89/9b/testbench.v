`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [89:0] in;
    wire [88:0] out_any;
    wire [88:0] out_both;
    wire [89:0] out_different;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_any(out_any),
        .out_both(out_both),
        .out_different(out_different)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in = 90'h0;
            #1;

            check_outputs(89'h0, 89'h0, 90'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 90'h3FFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(89'h1FFFFFFFFFFFFFFFFFFFFFF, 89'h1FFFFFFFFFFFFFFFFFFFFFF, 90'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 90'h15555555555555555555555;

            #1;


            check_outputs(89'h1FFFFFFFFFFFFFFFFFFFFFF, 89'h0, 90'h3FFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 90'h2AAAAAAAAAAAAAAAAAAAAAA;

            #1;


            check_outputs(89'h1FFFFFFFFFFFFFFFFFFFFFF, 89'h0, 90'h3FFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 90'h1;

            #1;


            check_outputs(89'h1, 89'h0, 90'h20000000000000000000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 90'h20000000000000000000000;

            #1;


            check_outputs(89'h10000000000000000000000, 89'h0, 90'h30000000000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 90'h3;

            #1;


            check_outputs(89'h3, 89'h1, 90'h20000000000000000000002);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in = 90'h30000000000000000000000;

            #1;


            check_outputs(89'h18000000000000000000000, 89'h10000000000000000000000, 90'h28000000000000000000000);
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
        input [88:0] expected_out_any;
        input [88:0] expected_out_both;
        input [89:0] expected_out_different;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_any === (expected_out_any ^ out_any ^ expected_out_any) &&
                expected_out_both === (expected_out_both ^ out_both ^ expected_out_both) &&
                expected_out_different === (expected_out_different ^ out_different ^ expected_out_different)) begin
                $display("PASS");
                $display("  Outputs: out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_any=%h, out_both=%h, out_different=%h",
                         expected_out_any, expected_out_both, expected_out_different);
                $display("  Got:      out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
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
