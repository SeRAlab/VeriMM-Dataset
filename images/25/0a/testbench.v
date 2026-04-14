`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_ref;
    wire [4:0] regulated_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .voltage_ref(voltage_ref),
        .regulated_voltage(regulated_voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum value (0)", test_num);
            voltage_ref = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small value (5)", test_num);
            voltage_ref = 5'd5;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary value - No Saturation (15)", test_num);
            voltage_ref = 5'd15;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary value - Saturation Start (16)", test_num);
            voltage_ref = 5'd16;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum input (31)", test_num);
            voltage_ref = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Middle value (10)", test_num);
            voltage_ref = 5'd10;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Value just above saturation (20)", test_num);
            voltage_ref = 5'd20;
            #1;

            check_outputs(5'd31);
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
        testcase007();
        
        
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
