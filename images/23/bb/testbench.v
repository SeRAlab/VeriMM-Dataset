`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] threshold;
    reg [4:0] voltage_in;
    wire alarm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .threshold(threshold),
        .voltage_in(voltage_in),
        .alarm(alarm)
    );
    task testcase001;

        begin
            test_num = 1;
            threshold = 5'd10;
            voltage_in = 5'd5;
            $display("Testcase %0d: Input below threshold (10). Voltage: %0d", test_num, voltage_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            threshold = 5'd10;
            voltage_in = 5'd10;
            $display("Testcase %0d: Input equal to threshold (10). Voltage: %0d", test_num, voltage_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            threshold = 5'd10;
            voltage_in = 5'd11;
            $display("Testcase %0d: Input just above threshold (10). Voltage: %0d", test_num, voltage_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            threshold = 5'd0;
            voltage_in = 5'd0;
            $display("Testcase %0d: Minimum boundary test (Threshold 0, Voltage 0).", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            threshold = 5'd0;
            voltage_in = 5'd1;
            $display("Testcase %0d: Minimum boundary test (Threshold 0, Voltage 1).", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            threshold = 5'd31;
            voltage_in = 5'd31;
            $display("Testcase %0d: Maximum boundary test (Threshold 31, Voltage 31).", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            threshold = 5'd30;
            voltage_in = 5'd31;
            $display("Testcase %0d: Maximum boundary test (Threshold 30, Voltage 31).", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            threshold = 5'd15;
            voltage_in = 5'd31;
            $display("Testcase %0d: Maximum voltage with mid threshold (15). Voltage: %0d", test_num, voltage_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            threshold = 5'd20;
            voltage_in = 5'd0;
            $display("Testcase %0d: Minimum voltage with high threshold (20). Voltage: %0d", test_num, voltage_in);
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
        $display("voltage_sensor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_alarm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alarm === (expected_alarm ^ alarm ^ expected_alarm)) begin
                $display("PASS");
                $display("  Outputs: alarm=%b",
                         alarm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm=%b",
                         expected_alarm);
                $display("  Got:      alarm=%b",
                         alarm);
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
