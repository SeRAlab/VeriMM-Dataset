`timescale 1ns/1ps

module power_gating_control_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg ps;
    wire gated_power;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_control dut (
        .en(en),
        .ps(ps),
        .gated_power(gated_power)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: en=0, ps=0", test_num);
            en = 0;
            ps = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: en=0, ps=1", test_num);
            en = 0;
            ps = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: en=1, ps=0", test_num);
            en = 1;
            ps = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: en=1, ps=1", test_num);
            en = 1;
            ps = 1;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating_control Testbench");
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
        input expected_gated_power;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gated_power === (expected_gated_power ^ gated_power ^ expected_gated_power)) begin
                $display("PASS");
                $display("  Outputs: gated_power=%b",
                         gated_power);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_power=%b",
                         expected_gated_power);
                $display("  Got:      gated_power=%b",
                         gated_power);
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
