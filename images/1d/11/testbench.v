`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] process_noise;
    reg reset;
    wire [15:0] estimate;

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
            measurement_noise = 0;
            process_noise = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero Measurement Noise Tracking", test_num);
            reset_dut();
            measurement = 16'h03E8;
            measurement_noise = 16'h0000;
            process_noise = 16'h0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h03E8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: High Noise Filtering", test_num);
            reset_dut();
            measurement = 16'hFFFF;
            measurement_noise = 16'hFFFF;
            process_noise = 16'h0001;


            repeat(5) @(posedge clk);
            #2;



            if (estimate < 16'h0100) begin
                $display("PASS: Estimate stayed low due to high R filtering");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Estimate increased too fast. Got: %h", estimate);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Convergence Test", test_num);
            reset_dut();
            measurement = 16'h0064;
            measurement_noise = 16'h0010;
            process_noise = 16'h0010;


            repeat(50) @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0064);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High Process Noise Reaction", test_num);
            reset_dut();
            measurement = 16'h1234;
            measurement_noise = 16'h0001;
            process_noise = 16'hFF00;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h1234);
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
        $dumpvars(0,clk, measurement, measurement_noise, process_noise, reset, estimate);
    end

endmodule
