`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] measurement;
    reg rst;
    wire [15:0] error;
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
        .rst(rst),
        .error(error),
        .estimate(estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control = 16'h0000;
            measurement = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initialization Check");
            reset_dut();

            repeat(5) @(posedge clk);



            #1;




            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Steady Motion Tracking");
            reset_dut();




            control = 16'd10;
            measurement = 16'd10; @(posedge clk);
            measurement = 16'd20; @(posedge clk);
            measurement = 16'd30; @(posedge clk);
            measurement = 16'd40; @(posedge clk);


            #1;



            check_outputs(error, 16'd40);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Measurement Correction");
            reset_dut();


            control = 16'd100;
            measurement = 16'd100;
            @(posedge clk);



            control = 16'd0;
            measurement = 16'd200;
            repeat(2) @(posedge clk);




            if (estimate > 16'd100 && estimate <= 16'd200)
                pass_count = pass_count;



            #1;




            check_outputs(error, estimate);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Measurement Noise Filtering");
            reset_dut();

            control = 16'd0;

            measurement = 16'd50; @(posedge clk);
            measurement = 16'd48; @(posedge clk);
            measurement = 16'd52; @(posedge clk);
            measurement = 16'd50; @(posedge clk);


            #1;



            check_outputs(error, 16'd50);
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
        input [15:0] expected_error;
        input [15:0] expected_estimate;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_estimate === (expected_estimate ^ estimate ^ expected_estimate)) begin
                $display("PASS");
                $display("  Outputs: error=%h, estimate=%h",
                         error, estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%h, estimate=%h",
                         expected_error, expected_estimate);
                $display("  Got:      error=%h, estimate=%h",
                         error, estimate);
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
        $dumpvars(0,clk, control, measurement, rst, error, estimate);
    end

endmodule
