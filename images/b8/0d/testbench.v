`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [49:0] in;
    reg sel;
    wire out_and;
    wire out_or;
    wire out_xnor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .out_and(out_and),
        .out_or(out_or),
        .out_xnor(out_xnor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=0, input=all 1s (Should treat as 0s)", test_num);
            in = {50{1'b1}};
            sel = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=1, input=all 0s", test_num);
            in = {50{1'b0}};
            sel = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=1, input=all 1s", test_num);
            in = {50{1'b1}};
            sel = 1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=1, input=only one bit high", test_num);
            in = 50'b0;
            in[25] = 1'b1;
            sel = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=1, input=all but one bit high", test_num);
            in = {50{1'b1}};
            in[10] = 1'b0;
            sel = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=1, input=exactly two bits high", test_num);
            in = 50'b0;
            in[0] = 1'b1;
            in[49] = 1'b1;
            sel = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=0, input=alternating bits (Should treat as 0s)", test_num);
            in = 50'hAAAAAAAAAAAAAAAAA;
            sel = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: sel=1, arbitrary pattern (even number of ones)", test_num);

            in = 50'b0;
            in[1] = 1'b1; in[2] = 1'b1; in[3] = 1'b1; in[4] = 1'b1;
            sel = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_out_and;
        input expected_out_or;
        input expected_out_xnor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xnor === (expected_out_xnor ^ out_xnor ^ expected_out_xnor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, out_or=%b, out_xnor=%b",
                         out_and, out_or, out_xnor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, out_or=%b, out_xnor=%b",
                         expected_out_and, expected_out_or, expected_out_xnor);
                $display("  Got:      out_and=%b, out_or=%b, out_xnor=%b",
                         out_and, out_or, out_xnor);
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
