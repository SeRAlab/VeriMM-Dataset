`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    wire LO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .LO(LO)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\n--- Test Case %0d: I0 = 0 ---", test_num);

            I0 = 1'b0;


            #10;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\n--- Test Case %0d: I0 = 1 ---", test_num);

            I0 = 1'b1;


            #10;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\n--- Test Case %0d: Transition 1 -> 0 ---", test_num);

            I0 = 1'b1;
            #5;

            I0 = 1'b0;

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
        input expected_LO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LO === (expected_LO ^ LO ^ expected_LO)) begin
                $display("PASS");
                $display("  Outputs: LO=%b",
                         LO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LO=%b",
                         expected_LO);
                $display("  Got:      LO=%b",
                         LO);
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
