`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg v;
    reg w;
    reg x;
    reg y;
    reg z;
    wire u;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .v(v),
        .w(w),
        .x(x),
        .y(y),
        .z(z),
        .u(u)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs 0 (NOR result is 1, OR with v=0 should be 1)", test_num);
            v = 0; w = 0; x = 0; y = 0; z = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=0, w=1 (NOR result is 0, OR with v=0 should be 0)", test_num);
            v = 0; w = 1; x = 0; y = 0; z = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=0, x=1 (NOR result is 0, OR with v=0 should be 0)", test_num);
            v = 0; w = 0; x = 1; y = 0; z = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=0, y=1 (NOR result is 0, OR with v=0 should be 0)", test_num);
            v = 0; w = 0; x = 0; y = 1; z = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=0, z=1 (NOR result is 0, OR with v=0 should be 0)", test_num);
            v = 0; w = 0; x = 0; y = 0; z = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=1, wxyz=0 (OR with v=1 should be 1)", test_num);
            v = 1; w = 0; x = 0; y = 0; z = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=1, all NOR inputs 1 (OR with v=1 should be 1)", test_num);
            v = 1; w = 1; x = 1; y = 1; z = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=0, all NOR inputs 1 (NOR is 0, OR with v=0 should be 0)", test_num);
            v = 0; w = 1; x = 1; y = 1; z = 1;
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
        input expected_u;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_u === (expected_u ^ u ^ expected_u)) begin
                $display("PASS");
                $display("  Outputs: u=%b",
                         u);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%b",
                         expected_u);
                $display("  Got:      u=%b",
                         u);
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
