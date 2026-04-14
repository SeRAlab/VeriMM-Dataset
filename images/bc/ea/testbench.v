`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] inY;
    wire reduced_AND;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inY(inY),
        .reduced_AND(reduced_AND)
    );
    task testcase001;

        begin
            inY = 8'b0000_0000;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            inY = 8'b0000_0001;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            inY = 8'b0000_0010;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            inY = 8'b0000_1000;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            inY = 8'b0001_0000;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            inY = 8'b1000_0000;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            inY = 8'b1010_1010;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            inY = 8'b1111_1111;
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1);
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
        input expected_reduced_AND;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reduced_AND === (expected_reduced_AND ^ reduced_AND ^ expected_reduced_AND)) begin
                $display("PASS");
                $display("  Outputs: reduced_AND=%b",
                         reduced_AND);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reduced_AND=%b",
                         expected_reduced_AND);
                $display("  Got:      reduced_AND=%b",
                         reduced_AND);
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
