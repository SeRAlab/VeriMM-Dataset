`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] outv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .outv(outv)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: a=0, b=0", test_num);
            a = 1'b0;
            b = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: a=0, b=1", test_num);
            a = 1'b0;
            b = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: a=1, b=0", test_num);
            a = 1'b1;
            b = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: a=1, b=1", test_num);
            a = 1'b1;
            b = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_outv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, outv=%h",
                         o0, o1, o2, outv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, outv=%h",
                         expected_o0, expected_o1, expected_o2, expected_outv);
                $display("  Got:      o0=%b, o1=%b, o2=%b, outv=%h",
                         o0, o1, o2, outv);
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
