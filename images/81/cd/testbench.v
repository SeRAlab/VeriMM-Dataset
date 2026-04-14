`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reading internal register y.z when value is 0", test_num);



            force dut.y.z = 1'b0;
            #10;

            #1;


            check_outputs(1'b0);
            release dut.y.z;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reading internal register y.z when value is 1", test_num);


            force dut.y.z = 1'b1;
            #10;

            #1;


            check_outputs(1'b1);
            release dut.y.z;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying dynamic change of y.z reflects on x", test_num);

            force dut.y.z = 1'b0;
            #5;
            force dut.y.z = 1'b1;
            #5;


            #1;



            check_outputs(1'b1);
            release dut.y.z;
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
        input expected_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: x=%b",
                         x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%b",
                         expected_x);
                $display("  Got:      x=%b",
                         x);
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
