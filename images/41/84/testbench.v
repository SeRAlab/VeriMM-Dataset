`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg activate_0r;
    reg inp_0a;
    reg inp_0d;
    reg out_0a;
    wire activate_0a;
    wire inp_0r;
    wire out_0d;
    wire out_0r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .activate_0r(activate_0r),
        .inp_0a(inp_0a),
        .inp_0d(inp_0d),
        .out_0a(out_0a),
        .activate_0a(activate_0a),
        .inp_0r(inp_0r),
        .out_0d(out_0d),
        .out_0r(out_0r)
    );
    task testcase001;

        begin
            test_num = 1;

            activate_0r = 0; inp_0a = 0; inp_0d = 0; out_0a = 0;
            #10;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            activate_0r = 0; inp_0a = 0; inp_0d = 0; out_0a = 0;
            #10;

            activate_0r = 1;
            #10;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            activate_0r = 0; inp_0a = 0; inp_0d = 0; out_0a = 0;
            #10;

            activate_0r = 1;
            #10;
            inp_0a = 1; inp_0d = 1;
            #10;

            #1;


            check_outputs(0, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            activate_0r = 0; inp_0a = 0; inp_0d = 0; out_0a = 0;
            #10;

            activate_0r = 1; #10;
            inp_0a = 1; inp_0d = 1; #10;
            out_0a = 1;
            #10;

            #1;


            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            activate_0r = 0; inp_0a = 0; inp_0d = 0; out_0a = 0;
            #10;

            activate_0r = 1; #10;
            inp_0a = 1; inp_0d = 0; #10;
            out_0a = 1;
            #10;

            #1;


            check_outputs(1, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            activate_0r = 0; inp_0a = 0; inp_0d = 0; out_0a = 0;
            #10;

            activate_0r = 1; inp_0a = 1; inp_0d = 1; out_0a = 1;
            #10;
            activate_0r = 0; inp_0a = 0; out_0a = 0;
            #10;

            #1;


            check_outputs(0, 0, 0, 0);
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
        input expected_activate_0a;
        input expected_inp_0r;
        input expected_out_0d;
        input expected_out_0r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_activate_0a === (expected_activate_0a ^ activate_0a ^ expected_activate_0a) &&
                expected_inp_0r === (expected_inp_0r ^ inp_0r ^ expected_inp_0r) &&
                expected_out_0d === (expected_out_0d ^ out_0d ^ expected_out_0d) &&
                expected_out_0r === (expected_out_0r ^ out_0r ^ expected_out_0r)) begin
                $display("PASS");
                $display("  Outputs: activate_0a=%b, inp_0r=%b, out_0d=%b, out_0r=%b",
                         activate_0a, inp_0r, out_0d, out_0r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: activate_0a=%b, inp_0r=%b, out_0d=%b, out_0r=%b",
                         expected_activate_0a, expected_inp_0r, expected_out_0d, expected_out_0r);
                $display("  Got:      activate_0a=%b, inp_0r=%b, out_0d=%b, out_0r=%b",
                         activate_0a, inp_0r, out_0d, out_0r);
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
