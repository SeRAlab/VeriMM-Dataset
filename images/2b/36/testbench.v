`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
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
            measurement = 16'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            $display("\nRunning testcase001: Constant Input Convergence");
            reset_dut();
            test_num = test_num + 1;


            for (i = 0; i < 64; i = i + 1) begin
                measurement = 16'd500;
                @(posedge clk);
            end


            #1;



            check_outputs(16'd500);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("\nRunning testcase002: Step Response");
            reset_dut();
            test_num = test_num + 1;


            for (i = 0; i < 32; i = i + 1) begin
                measurement = 16'd100;
                @(posedge clk);
            end


            for (i = 0; i < 64; i = i + 1) begin
                measurement = 16'd2000;
                @(posedge clk);
            end

            #1;


            check_outputs(16'd2000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Large Value Filtering");
            reset_dut();
            test_num = test_num + 1;


            for (i = 0; i < 100; i = i + 1) begin
                measurement = 16'hF000;
                @(posedge clk);
            end

            #1;


            check_outputs(16'hF000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Zero Input Check");
            reset_dut();
            test_num = test_num + 1;


            for (i = 0; i < 20; i = i + 1) begin
                measurement = 16'd1234;
                @(posedge clk);
            end


            for (i = 0; i < 80; i = i + 1) begin
                measurement = 16'd0;
                @(posedge clk);
            end

            #1;


            check_outputs(16'd0);
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
        $dumpvars(0,clk, measurement, reset, estimate);
    end

endmodule
