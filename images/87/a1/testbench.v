`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg angle;
    wire cos;
    wire sin;
    wire tan;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .angle(angle),
        .cos(cos),
        .sin(sin),
        .tan(tan)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Angle = 0", test_num);


            angle = 1'b0;



            #1;




            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Angle = 1", test_num);


            angle = 1'b1;



            #1;




            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transition Angle 1 -> 0", test_num);


            angle = 1'b1;
            #5;

            angle = 1'b0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Toggle check", test_num);

            angle = 1'b0; #2;
            angle = 1'b1; #2;
            angle = 1'b0; #2;
            angle = 1'b1;


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
        input expected_cos;
        input expected_sin;
        input expected_tan;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cos === (expected_cos ^ cos ^ expected_cos) &&
                expected_sin === (expected_sin ^ sin ^ expected_sin) &&
                expected_tan === (expected_tan ^ tan ^ expected_tan)) begin
                $display("PASS");
                $display("  Outputs: cos=%b, sin=%b, tan=%b",
                         cos, sin, tan);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cos=%b, sin=%b, tan=%b",
                         expected_cos, expected_sin, expected_tan);
                $display("  Got:      cos=%b, sin=%b, tan=%b",
                         cos, sin, tan);
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
