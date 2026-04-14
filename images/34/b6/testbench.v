`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] previous_estimate;
    reg reset;
    wire [15:0] new_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .previous_estimate(previous_estimate),
        .reset(reset),
        .new_estimate(new_estimate)
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
            previous_estimate = 16'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Steady State - No change in estimate", test_num);
            reset_dut();
            measurement = 16'd1000;
            previous_estimate = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Step Change", test_num);
            reset_dut();
            measurement = 16'd2000;
            previous_estimate = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Step Change", test_num);
            reset_dut();
            measurement = 16'd1000;
            previous_estimate = 16'd2000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Initialization", test_num);
            reset_dut();
            measurement = 16'd5000;
            previous_estimate = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd2500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Range Steady State", test_num);
            reset_dut();
            measurement = 16'hFFFE;
            previous_estimate = 16'hFFFE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Filtering Noise (Small Increment)", test_num);
            reset_dut();
            measurement = 16'd1010;
            previous_estimate = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1005);
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
        testcase006();
        
        
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
        input [15:0] expected_new_estimate;
        begin
            if (expected_new_estimate === (expected_new_estimate ^ new_estimate ^ expected_new_estimate)) begin
                $display("PASS");
                $display("  Outputs: new_estimate=%h",
                         new_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_estimate=%h",
                         expected_new_estimate);
                $display("  Got:      new_estimate=%h",
                         new_estimate);
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
        $dumpvars(0,clk, measurement, previous_estimate, reset, new_estimate);
    end

endmodule
