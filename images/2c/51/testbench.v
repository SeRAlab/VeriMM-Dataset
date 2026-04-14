`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current;
    reg [4:0] desired_voltage;
    wire [4:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .current(current),
        .desired_voltage(desired_voltage),
        .control_signal(control_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        current = 5'd10;
        desired_voltage = 5'd20;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        current = 5'd25;
        desired_voltage = 5'd15;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        current = 5'd15;
        desired_voltage = 5'd15;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        current = 5'd30;
        desired_voltage = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        current = 5'd1;
        desired_voltage = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        current = 5'd31;
        desired_voltage = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        current = 5'd0;
        desired_voltage = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        current = 5'd0;
        desired_voltage = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        current = 5'd31;
        desired_voltage = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcases1;

    begin
        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
    end
        endtask

    task testcases2;

    begin
        testcase006();
        testcase007();
        testcase008();
        testcase009();
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
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcases1();
        testcases2();
        
        
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
        input [4:0] expected_control_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
