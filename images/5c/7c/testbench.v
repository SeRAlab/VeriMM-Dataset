`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    reg in5;
    reg in6;
    reg in7;
    reg in8;
    wire out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .out1(out1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Logic 0 OR 0", test_num);

            in5 = 1'b1;
            in6 = 1'b0;
            in7 = 1'b1;
            in8 = 1'b0;
            in3 = 1'b0;
            in4 = 1'b0;


            in1 = 1'b0;
            in2 = 1'b0;

            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Logic 0 OR 1", test_num);
            in5 = 1'b1; in6 = 1'b0; in7 = 1'b1; in8 = 1'b0;
            in3 = 1'b0; in4 = 1'b0;

            in1 = 1'b0;
            in2 = 1'b1;

            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Logic 1 OR 0", test_num);
            in5 = 1'b1; in6 = 1'b0; in7 = 1'b1; in8 = 1'b0;
            in3 = 1'b0; in4 = 1'b0;

            in1 = 1'b1;
            in2 = 1'b0;

            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Logic 1 OR 1", test_num);
            in5 = 1'b1; in6 = 1'b0; in7 = 1'b1; in8 = 1'b0;
            in3 = 1'b0; in4 = 1'b0;

            in1 = 1'b1;
            in2 = 1'b1;

            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing signal inputs in3/in4 influence", test_num);
            in5 = 1'b1; in6 = 1'b0; in7 = 1'b1; in8 = 1'b0;

            in1 = 1'b0;
            in2 = 1'b0;
            in3 = 1'b1;
            in4 = 1'b1;

            #10;

            #1;


            check_outputs(1'b0);
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
        input expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%b",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b",
                         expected_out1);
                $display("  Got:      out1=%b",
                         out1);
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
