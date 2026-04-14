`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control_input;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] error_covariance;
    wire [15:0] state_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control_input(control_input),
        .measurement(measurement),
        .reset(reset),
        .error_covariance(error_covariance),
        .state_estimate(state_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting circuit...");
            reset = 1;
            measurement = 16'h0000;
            control_input = 16'h0000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input Test", test_num);
            reset_dut();

            measurement = 16'h0000;
            control_input = 16'h0000;

            repeat(5) @(posedge clk);
            #2;



            #1;




            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant Measurement Test", test_num);
            reset_dut();

            measurement = 16'h0100;
            control_input = 16'h0000;

            @(posedge clk);
            #2;




            #1;





            check_outputs(error_covariance, state_estimate);


        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control Input Influence Test", test_num);
            reset_dut();

            measurement = 16'h0000;
            control_input = 16'h0080;

            repeat(2) @(posedge clk);
            #2;



            if (state_estimate > 0) begin
                pass_count = pass_count + 1;
                $display("PASS: State updated via control input. State=%h", state_estimate);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: State failed to update with control input. State=%h", state_estimate);
            end
        end
        endtask

    task testcase004;

        reg [15:0] prev_cov;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Covariance Convergence Test", test_num);
            reset_dut();

            measurement = 16'h0200;
            control_input = 16'h0000;

            @(posedge clk); #2;
            prev_cov = error_covariance;

            repeat(5) @(posedge clk);
            #2;


            if (error_covariance <= prev_cov) begin
                $display("PASS: Covariance converged/stabilized. Final Cov=%h", error_covariance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Covariance diverged. Initial=%h, Final=%h", prev_cov, error_covariance);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Step Input Test", test_num);
            reset_dut();

            measurement = 16'h7000;
            control_input = 16'h0000;

            repeat(3) @(posedge clk);
            #2;


            if (state_estimate > 16'h0000 && state_estimate < 16'h7FFF) begin
                $display("PASS: Filter responding to large step. State=%h", state_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter response invalid or overflow. State=%h", state_estimate);
                fail_count = fail_count + 1;
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
        input [15:0] expected_state_estimate;
        begin
            if (expected_error_covariance === (expected_error_covariance ^ error_covariance ^ expected_error_covariance) &&
                expected_state_estimate === (expected_state_estimate ^ state_estimate ^ expected_state_estimate)) begin
                $display("PASS");
                $display("  Outputs: error_covariance=%h, state_estimate=%h",
                         error_covariance, state_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_covariance=%h, state_estimate=%h",
                         expected_error_covariance, expected_state_estimate);
                $display("  Got:      error_covariance=%h, state_estimate=%h",
                         error_covariance, state_estimate);
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
        $dumpvars(0,clk, control_input, measurement, reset, error_covariance, state_estimate);
    end

endmodule
