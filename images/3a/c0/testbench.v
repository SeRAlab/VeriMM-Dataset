`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control_input;
    reg [15:0] measurement_input;
    reg reset;
    wire [15:0] error_covariance;
    wire [15:0] estimated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control_input(control_input),
        .measurement_input(measurement_input),
        .reset(reset),
        .error_covariance(error_covariance),
        .estimated_state(estimated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_input = 16'h0000;
            measurement_input = 16'h0000;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Initialization Check", test_num);
            reset_dut();



            #1;




            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Steady State Convergence", test_num);
            reset_dut();

            control_input = 16'h0000;
            measurement_input = 16'h0100;


            repeat(20) @(posedge clk);



            #1;




            check_outputs(16'h00A0, 16'h00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Control Input (Prediction Only)", test_num);
            reset_dut();

            control_input = 16'h0010;
            measurement_input = 16'h0000;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h00B0, 16'h0050);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Measurement Step Response", test_num);
            reset_dut();

            control_input = 16'h0000;
            measurement_input = 16'h0000;
            repeat(5) @(posedge clk);

            measurement_input = 16'h0500;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h0100, 16'h0320);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Zero Input Stability", test_num);
            reset_dut();

            control_input = 16'h0000;
            measurement_input = 16'h0000;

            repeat(50) @(posedge clk);


            #1;



            check_outputs(16'h0010, 16'h0000);
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
        input [15:0] expected_error_covariance;
        input [15:0] expected_estimated_state;
        begin
            if (expected_error_covariance === (expected_error_covariance ^ error_covariance ^ expected_error_covariance) &&
                expected_estimated_state === (expected_estimated_state ^ estimated_state ^ expected_estimated_state)) begin
                $display("PASS");
                $display("  Outputs: error_covariance=%h, estimated_state=%h",
                         error_covariance, estimated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_covariance=%h, estimated_state=%h",
                         expected_error_covariance, expected_estimated_state);
                $display("  Got:      error_covariance=%h, estimated_state=%h",
                         error_covariance, estimated_state);
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
        $dumpvars(0,clk, control_input, measurement_input, reset, error_covariance, estimated_state);
    end

endmodule
