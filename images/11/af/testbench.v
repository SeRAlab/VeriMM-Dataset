`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg req;
    wire pwr_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .ctrl(ctrl),
        .req(req),
        .pwr_en(pwr_en)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both signals low", test_num);
            ctrl = 1'b0;
            req = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only req high", test_num);
            ctrl = 1'b0;
            req = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only ctrl high", test_num);
            ctrl = 1'b1;
            req = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both signals high", test_num);
            ctrl = 1'b1;
            req = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Active to Idle (req drops)", test_num);
            ctrl = 1'b1;
            req = 1'b1;
            #5;
            req = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Active to Power Gated (ctrl drops)", test_num);
            ctrl = 1'b1;
            req = 1'b1;
            #5;
            ctrl = 1'b0;
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
        $display("power_gating Testbench");
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
        input expected_pwr_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pwr_en === (expected_pwr_en ^ pwr_en ^ expected_pwr_en)) begin
                $display("PASS");
                $display("  Outputs: pwr_en=%b",
                         pwr_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwr_en=%b",
                         expected_pwr_en);
                $display("  Got:      pwr_en=%b",
                         pwr_en);
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
