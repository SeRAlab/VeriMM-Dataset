`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] process_noise;
    reg reset;
    wire [15:0] estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .measurement_noise(measurement_noise),
        .process_noise(process_noise),
        .reset(reset),
        .estimated_position(estimated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 16'h0;
            measurement_noise = 16'h0;
            process_noise = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Steady State Convergence", test_num);
            reset_dut();

            measurement = 16'd1000;
            measurement_noise = 16'd10;
            process_noise = 16'd2;


            repeat(50) @(posedge clk);


            #1;



            check_outputs(16'h03E8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Step Change Response", test_num);
            reset_dut();

            measurement = 16'd5000;
            measurement_noise = 16'd5;
            process_noise = 16'd10;


            repeat(40) @(posedge clk);


            #1;



            check_outputs(16'h1388);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Measurement Noise (Smoothing)", test_num);
            reset_dut();

            measurement = 16'd8000;
            measurement_noise = 16'hFFFF;
            process_noise = 16'd1;


            repeat(10) @(posedge clk);



            if (estimated_position < 16'd2000) begin
                $display("PASS: Filter correctly suppressed noisy jump.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter moved too fast for high noise setting.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input Verification", test_num);
            reset_dut();

            measurement = 16'h0;
            measurement_noise = 16'h0010;
            process_noise = 16'h0001;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Process Noise (Fast Tracking)", test_num);
            reset_dut();

            measurement = 16'd3000;
            measurement_noise = 16'd1;
            process_noise = 16'h0FFF;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0BB8);
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
        input [15:0] expected_estimated_position;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h",
                         estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h",
                         expected_estimated_position);
                $display("  Got:      estimated_position=%h",
                         estimated_position);
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
        $dumpvars(0,clk, measurement, measurement_noise, process_noise, reset, estimated_position);
    end

endmodule
