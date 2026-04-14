`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] estimated_state;
    reg [15:0] measured_value;
    reg [15:0] measurement_noise;
    reg [15:0] process_noise;
    wire [15:0] updated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .estimated_state(estimated_state),
        .measured_value(measured_value),
        .measurement_noise(measurement_noise),
        .process_noise(process_noise),
        .updated_state(updated_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal noise (Weighted Average)", test_num);

            estimated_state = 16'd1000;
            measured_value = 16'd2000;
            process_noise = 16'd50;
            measurement_noise = 16'd50;
            #1;

            check_outputs(16'd1500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Measurement Noise (Trust State)", test_num);

            estimated_state = 16'd1000;
            measured_value = 16'd2000;
            process_noise = 16'd25;
            measurement_noise = 16'd75;
            #1;

            check_outputs(16'd1250);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Process Noise (Trust Measurement)", test_num);

            estimated_state = 16'd1000;
            measured_value = 16'd2000;
            process_noise = 16'd75;
            measurement_noise = 16'd25;
            #1;

            check_outputs(16'd1750);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Measured equals Estimated", test_num);

            estimated_state = 16'd5000;
            measured_value = 16'd5000;
            process_noise = 16'd100;
            measurement_noise = 16'd20;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Near-Zero Process Noise (Freeze State)", test_num);

            estimated_state = 16'd4000;
            measured_value = 16'd8000;
            process_noise = 16'd1;
            measurement_noise = 16'd99;
            #1;

            check_outputs(16'd4040);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Near-Zero Measurement Noise (Follow Measurement)", test_num);

            estimated_state = 16'd4000;
            measured_value = 16'd8000;
            process_noise = 16'd99;
            measurement_noise = 16'd1;
            #1;

            check_outputs(16'd7960);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Values", test_num);
            estimated_state = 16'h0000;
            measured_value = 16'h0000;
            process_noise = 16'd10;
            measurement_noise = 16'd10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Scale Values", test_num);


            estimated_state = 16'd100;
            measured_value = 16'd200;
            process_noise = 16'h7FFF;
            measurement_noise = 16'h7FFF;
            #1;

            check_outputs(16'd150);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_updated_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_state === (expected_updated_state ^ updated_state ^ expected_updated_state)) begin
                $display("PASS");
                $display("  Outputs: updated_state=%h",
                         updated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_state=%h",
                         expected_updated_state);
                $display("  Got:      updated_state=%h",
                         updated_state);
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
