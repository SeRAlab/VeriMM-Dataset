`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] noisy_measurement;
    reg rst;
    wire [15:0] filtered_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .noisy_measurement(noisy_measurement),
        .rst(rst),
        .filtered_value(filtered_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        noisy_measurement = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase %0d: Zero Stability", test_num);
        reset_dut();

        repeat(10) begin
            noisy_measurement = 16'h0000;
            @(posedge clk);
        end
        #1;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase %0d: DC Convergence", test_num);
        reset_dut();


        repeat(50) begin
            noisy_measurement = 16'h03E8;
            @(posedge clk);
        end
        #1;

        #1;


        check_outputs(16'h03E8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning Testcase %0d: Step Response", test_num);
        reset_dut();


        repeat(20) begin
            noisy_measurement = 16'h1000;
            @(posedge clk);
        end


        repeat(50) begin
            noisy_measurement = 16'h5000;
            @(posedge clk);
        end
        #1;

        #1;


        check_outputs(16'h5000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nRunning Testcase %0d: Noise Filtering", test_num);
        reset_dut();

        repeat(25) begin
            noisy_measurement = 16'h2000;
            @(posedge clk);
            noisy_measurement = 16'h2010;
            @(posedge clk);
        end
        #1;


        #1;



        check_outputs(16'h2010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nRunning Testcase %0d: Full Scale Check", test_num);
        reset_dut();

        repeat(40) begin
            noisy_measurement = 16'hFFFF;
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        input [15:0] expected_filtered_value;
        begin
            if (expected_filtered_value === (expected_filtered_value ^ filtered_value ^ expected_filtered_value)) begin
                $display("PASS");
                $display("  Outputs: filtered_value=%h",
                         filtered_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_value=%h",
                         expected_filtered_value);
                $display("  Got:      filtered_value=%h",
                         filtered_value);
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
        $dumpvars(0,clk, noisy_measurement, rst, filtered_value);
    end

endmodule
