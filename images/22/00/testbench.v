`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg module1_status;
    reg module2_status;
    wire module1_power;
    wire module2_power;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .enable(enable),
        .module1_status(module1_status),
        .module2_status(module2_status),
        .module1_power(module1_power),
        .module2_power(module2_power)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: enable=0, both modules idle", test_num);
        enable = 0;
        module1_status = 0;
        module2_status = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: enable=0, both modules active (should stay off)", test_num);
        enable = 0;
        module1_status = 1;
        module2_status = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: enable=1, both modules idle", test_num);
        enable = 1;
        module1_status = 0;
        module2_status = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: enable=1, module 1 active, module 2 idle", test_num);
        enable = 1;
        module1_status = 1;
        module2_status = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: enable=1, module 1 idle, module 2 active", test_num);
        enable = 1;
        module1_status = 0;
        module2_status = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: enable=1, both modules active", test_num);
        enable = 1;
        module1_status = 1;
        module2_status = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Transition from enable=1 (both active) to enable=0", test_num);

        enable = 1; module1_status = 1; module2_status = 1;
        #5;

        enable = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: module1 goes idle while enable is high", test_num);
        enable = 1;
        module1_status = 1;
        module2_status = 1;
        #5;
        module1_status = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating_controller Testbench");
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
        input expected_module1_power;
        input expected_module2_power;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_module1_power === (expected_module1_power ^ module1_power ^ expected_module1_power) &&
                expected_module2_power === (expected_module2_power ^ module2_power ^ expected_module2_power)) begin
                $display("PASS");
                $display("  Outputs: module1_power=%b, module2_power=%b",
                         module1_power, module2_power);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: module1_power=%b, module2_power=%b",
                         expected_module1_power, expected_module2_power);
                $display("  Got:      module1_power=%b, module2_power=%b",
                         module1_power, module2_power);
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
