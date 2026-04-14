`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control_input;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] prev_state;
    reg [15:0] process_noise;
    reg reset;
    wire [15:0] updated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control_input(control_input),
        .measurement(measurement),
        .measurement_noise(measurement_noise),
        .prev_state(prev_state),
        .process_noise(process_noise),
        .reset(reset),
        .updated_state(updated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_input = 0;
            measurement = 0;
            measurement_noise = 0;
            prev_state = 0;
            process_noise = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs", test_num);
            reset_dut();

            prev_state = 16'h0000;
            control_input = 16'h0000;
            measurement = 16'h0000;
            process_noise = 16'h0001;
            measurement_noise = 16'h0001;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trust Measurement (R=0)", test_num);
            reset_dut();

            prev_state = 16'd100;
            control_input = 16'd10;
            measurement = 16'd200;
            process_noise = 16'd10;
            measurement_noise = 16'd0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trust Prediction (Q=0)", test_num);
            reset_dut();

            prev_state = 16'd500;
            control_input = 16'd50;
            measurement = 16'd1000;
            process_noise = 16'd0;
            measurement_noise = 16'd100;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd550);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Balanced Noise (Q=R)", test_num);
            reset_dut();

            prev_state = 16'd1000;
            control_input = 16'd0;
            measurement = 16'd2000;
            process_noise = 16'd50;
            measurement_noise = 16'd50;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd1500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Control Input", test_num);
            reset_dut();

            prev_state = 16'd10;
            control_input = 16'd90;
            measurement = 16'd250;
            process_noise = 16'd1;
            measurement_noise = 16'd2;


            repeat(2) @(posedge clk);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, control_input, measurement, measurement_noise, prev_state, process_noise, reset, updated_state);
    end

endmodule
