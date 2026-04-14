`timescale 1ns/1ps

module core_module_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s;
    wire [3:0] mux_inputs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    core_module dut (
        .r(r),
        .s(s),
        .mux_inputs(mux_inputs)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            r = 1'b0; s = 1'b0;
            $display("Test %0d: r=0, s=0", test_num);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            r = 1'b0; s = 1'b1;
            $display("Test %0d: r=0, s=1", test_num);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            r = 1'b1; s = 1'b0;
            $display("Test %0d: r=1, s=0", test_num);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            r = 1'b1; s = 1'b1;
            $display("Test %0d: r=1, s=1", test_num);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("core_module Testbench");
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
        input [3:0] expected_mux_inputs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_inputs === (expected_mux_inputs ^ mux_inputs ^ expected_mux_inputs)) begin
                $display("PASS");
                $display("  Outputs: mux_inputs=%h",
                         mux_inputs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_inputs=%h",
                         expected_mux_inputs);
                $display("  Got:      mux_inputs=%h",
                         mux_inputs);
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
