`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] input_voltage;
    reg [4:0] reference_voltage;
    wire output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .input_voltage(input_voltage),
        .reference_voltage(reference_voltage),
        .output_signal(output_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input > Reference (Normal)", test_num);
            input_voltage = 5'd20;
            reference_voltage = 5'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input < Reference (Normal)", test_num);
            input_voltage = 5'd5;
            reference_voltage = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input == Reference (Boundary)", test_num);
            input_voltage = 5'd12;
            reference_voltage = 5'd12;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Input, Min Reference", test_num);
            input_voltage = 5'd31;
            reference_voltage = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Input, Max Reference", test_num);
            input_voltage = 5'd0;
            reference_voltage = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            input_voltage = 5'd0;
            reference_voltage = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            input_voltage = 5'd31;
            reference_voltage = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input just above Reference", test_num);
            input_voltage = 5'd16;
            reference_voltage = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input just below Reference", test_num);
            input_voltage = 5'd14;
            reference_voltage = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            input_voltage = 5'b10101;
            reference_voltage = 5'b01010;
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
        testcase010();
        
        
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
        input expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%b",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%b",
                         expected_output_signal);
                $display("  Got:      output_signal=%b",
                         output_signal);
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
