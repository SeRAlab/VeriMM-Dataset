`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] desired_voltage;
    wire [4:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .desired_voltage(desired_voltage),
        .output_voltage(output_voltage)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 0", test_num);
        desired_voltage = 5'd0;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 31", test_num);
        desired_voltage = 5'd31;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 1", test_num);
        desired_voltage = 5'd1;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 30", test_num);
        desired_voltage = 5'd30;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 15", test_num);
        desired_voltage = 5'd15;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 16", test_num);
        desired_voltage = 5'd16;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 10", test_num);
        desired_voltage = 5'd10;
        #1;

        check_outputs(5'd21);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 21", test_num);
        desired_voltage = 5'd21;
        #1;

        check_outputs(5'd10);
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
        input [4:0] expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
                         output_voltage);
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
