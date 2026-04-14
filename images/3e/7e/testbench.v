`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg enable;
    wire power_gate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .ctrl(ctrl),
        .enable(enable),
        .power_gate(power_gate)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low, Ctrl 00", test_num);
            enable = 1'b0;
            ctrl = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low, Ctrl 01", test_num);
            enable = 1'b0;
            ctrl = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low, Ctrl 10", test_num);
            enable = 1'b0;
            ctrl = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low, Ctrl 11", test_num);
            enable = 1'b0;
            ctrl = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Ctrl 00", test_num);
            enable = 1'b1;
            ctrl = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Ctrl 01", test_num);
            enable = 1'b1;
            ctrl = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Ctrl 10", test_num);
            enable = 1'b1;
            ctrl = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Ctrl 11 (Active Gating Condition)", test_num);
            enable = 1'b1;
            ctrl = 2'b11;
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
        $display("power_gating Testbench");
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
        input expected_power_gate;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_gate === (expected_power_gate ^ power_gate ^ expected_power_gate)) begin
                $display("PASS");
                $display("  Outputs: power_gate=%b",
                         power_gate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_gate=%b",
                         expected_power_gate);
                $display("  Got:      power_gate=%b",
                         power_gate);
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
