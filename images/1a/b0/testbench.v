`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control(control),
        .measurement(measurement),
        .reset(reset),
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
            control = 16'h0000;
            measurement = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Constant Measurement Convergence");
            test_num = 2;
            reset_dut();

            measurement = 16'h1000;
            control = 16'h0000;



            repeat(50) @(posedge clk);


            #1;



            check_outputs(16'h1000);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Control Input Prediction");
            test_num = 3;
            reset_dut();


            control = 16'h0500;
            measurement = 16'h0000;

            @(posedge clk);
            @(posedge clk);



            if (estimate > 16'h0000) begin
                $display("PASS: Control input influenced the estimate.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Control input had no effect.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Tracking Moving State");
            test_num = 4;
            reset_dut();



            control = 16'h0100;
            measurement = 16'h0100; @(posedge clk);
            measurement = 16'h0200; @(posedge clk);
            measurement = 16'h0300; @(posedge clk);
            measurement = 16'h0400; @(posedge clk);
            measurement = 16'h0500; @(posedge clk);

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h0500);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Noise Rejection");
            test_num = 5;
            reset_dut();

            control = 16'h0000;

            repeat(10) begin
                measurement = 16'h2000; @(posedge clk);
                measurement = 16'h2200; @(posedge clk);
            end



            if (estimate > 16'h2000 && estimate < 16'h2200) begin
                $display("PASS: Estimate is filtered (Value: %h)", estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter did not settle in range (Value: %h)", estimate);
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
        input [15:0] expected_estimate;
        begin
            if (expected_estimate === (expected_estimate ^ estimate ^ expected_estimate)) begin
                $display("PASS");
                $display("  Outputs: estimate=%h",
                         estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimate=%h",
                         expected_estimate);
                $display("  Got:      estimate=%h",
                         estimate);
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
        $dumpvars(0,clk, control, measurement, reset, estimate);
    end

endmodule
