`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measured_state;
    reg [15:0] measurement_noise_covariance;
    reg [15:0] predicted_state;
    reg [15:0] process_noise_covariance;
    reg reset;
    wire [15:0] corrected_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measured_state(measured_state),
        .measurement_noise_covariance(measurement_noise_covariance),
        .predicted_state(predicted_state),
        .process_noise_covariance(process_noise_covariance),
        .reset(reset),
        .corrected_state(corrected_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measured_state = 0;
            measurement_noise_covariance = 0;
            predicted_state = 0;
            process_noise_covariance = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            predicted_state = 16'd100;
            measured_state = 16'd200;
            process_noise_covariance = 16'd10;
            measurement_noise_covariance = 16'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0096);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            predicted_state = 16'd500;
            measured_state = 16'd1000;
            process_noise_covariance = 16'd0;
            measurement_noise_covariance = 16'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h01F4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            predicted_state = 16'd500;
            measured_state = 16'd1000;
            process_noise_covariance = 16'd100;
            measurement_noise_covariance = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h03E8);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            predicted_state = 16'd100;
            measured_state = 16'd200;
            process_noise_covariance = 16'd30;
            measurement_noise_covariance = 16'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00AF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            predicted_state = 16'd10000;
            measured_state = 16'd20000;
            process_noise_covariance = 16'd100;
            measurement_noise_covariance = 16'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3A98);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            predicted_state = 16'd1234;
            measured_state = 16'd1234;
            process_noise_covariance = 16'd50;
            measurement_noise_covariance = 16'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h04D2);
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
        input [15:0] expected_corrected_state;
        begin
            if (expected_corrected_state === (expected_corrected_state ^ corrected_state ^ expected_corrected_state)) begin
                $display("PASS");
                $display("  Outputs: corrected_state=%h",
                         corrected_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: corrected_state=%h",
                         expected_corrected_state);
                $display("  Got:      corrected_state=%h",
                         corrected_state);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, measured_state, measurement_noise_covariance, predicted_state, process_noise_covariance, reset, corrected_state);
    end

endmodule
