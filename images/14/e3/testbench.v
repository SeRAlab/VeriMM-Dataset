`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] error_estimate;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .error_estimate(error_estimate),
        .estimate(estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 0;
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
            $display("Running Testcase %03d: Steady State Convergence", test_num);
            reset_dut();


            repeat(50) begin
                measurement = 16'h03E8;
                @(posedge clk);
            end



            #1;




            check_outputs(16'h0001, 16'h03E8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Step Response tracking", test_num);
            reset_dut();


            repeat(20) begin
                measurement = 16'h0064;
                @(posedge clk);
            end


            repeat(50) begin
                measurement = 16'h1388;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h0001, 16'h1388);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Noisy Input Smoothing", test_num);
            reset_dut();

            repeat(40) begin
                measurement = 16'h01F4;
                @(posedge clk);
                measurement = 16'h0258;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h0002, 16'h0226);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Zero Input Check", test_num);
            reset_dut();

            measurement = 16'h0000;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_error_estimate;
        input [15:0] expected_estimate;
        begin
            if (expected_error_estimate === (expected_error_estimate ^ error_estimate ^ expected_error_estimate) &&
                expected_estimate === (expected_estimate ^ estimate ^ expected_estimate)) begin
                $display("PASS");
                $display("  Outputs: error_estimate=%h, estimate=%h",
                         error_estimate, estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_estimate=%h, estimate=%h",
                         expected_error_estimate, expected_estimate);
                $display("  Got:      error_estimate=%h, estimate=%h",
                         error_estimate, estimate);
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
        $dumpvars(0,clk, measurement, reset, error_estimate, estimate);
    end

endmodule
