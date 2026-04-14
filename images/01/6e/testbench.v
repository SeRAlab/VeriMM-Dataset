`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] voltage_select;
    wire regulator_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .voltage_select(voltage_select),
        .regulator_enable(regulator_enable)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input voltage_select = 00 (0V)", test_num);
            voltage_select = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input voltage_select = 01 (1.2V)", test_num);
            voltage_select = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input voltage_select = 10 (2.5V)", test_num);
            voltage_select = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input voltage_select = 11 (5V)", test_num);
            voltage_select = 2'b11;
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
        $display("switching_regulator Testbench");
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
        input expected_regulator_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regulator_enable === (expected_regulator_enable ^ regulator_enable ^ expected_regulator_enable)) begin
                $display("PASS");
                $display("  Outputs: regulator_enable=%b",
                         regulator_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regulator_enable=%b",
                         expected_regulator_enable);
                $display("  Got:      regulator_enable=%b",
                         regulator_enable);
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
