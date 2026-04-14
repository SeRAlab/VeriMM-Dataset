`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] state;
    wire horizontalsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .state(state),
        .horizontalsync(horizontalsync)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: state = 0 (Lower Bound)", test_num);
            state = 10'd0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: state = 95 (Boundary Inclusive)", test_num);
            state = 10'd95;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: state = 96 (Boundary Exclusive)", test_num);
            state = 10'd96;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: state = 50", test_num);
            state = 10'd50;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: state = 200", test_num);
            state = 10'd200;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: state = 1023 (Max Value)", test_num);
            state = 10'd1023;
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
        input expected_horizontalsync;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_horizontalsync === (expected_horizontalsync ^ horizontalsync ^ expected_horizontalsync)) begin
                $display("PASS");
                $display("  Outputs: horizontalsync=%b",
                         horizontalsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: horizontalsync=%b",
                         expected_horizontalsync);
                $display("  Got:      horizontalsync=%b",
                         horizontalsync);
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
