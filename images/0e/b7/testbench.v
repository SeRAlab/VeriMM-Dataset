`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] desired_voltage;
    wire [4:0] regulated_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .desired_voltage(desired_voltage),
        .regulated_voltage(regulated_voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum Voltage", test_num);
            desired_voltage = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Voltage", test_num);
            desired_voltage = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range Voltage (15)", test_num);
            desired_voltage = 5'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low-range Voltage (7)", test_num);
            desired_voltage = 5'd7;
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High-range Voltage (24)", test_num);
            desired_voltage = 5'd24;
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("\nTestcase 006: Exhaustive Sweep 0-31");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                desired_voltage = i;
                #1;

                check_outputs(i);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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
        input [4:0] expected_regulated_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regulated_voltage === (expected_regulated_voltage ^ regulated_voltage ^ expected_regulated_voltage)) begin
                $display("PASS");
                $display("  Outputs: regulated_voltage=%h",
                         regulated_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regulated_voltage=%h",
                         expected_regulated_voltage);
                $display("  Got:      regulated_voltage=%h",
                         regulated_voltage);
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
