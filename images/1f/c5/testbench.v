`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] estimated_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .rst(rst),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .estimated_value(estimated_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sensor1 = 0;
            sensor2 = 0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero Input Stability", test_num);
            reset_dut();
            sensor1 = 16'h0000;
            sensor2 = 16'h0000;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Constant Identical Inputs", test_num);
            reset_dut();
            sensor1 = 16'h1000;
            sensor2 = 16'h1000;

            repeat(30) @(posedge clk);
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Simple Fusion (Midpoint)", test_num);
            reset_dut();
            sensor1 = 16'h2000;
            sensor2 = 16'h4000;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(16'h3000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Large Scale Values", test_num);
            reset_dut();
            sensor1 = 16'hAAAA;
            sensor2 = 16'h5554;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Outlier Handling", test_num);
            reset_dut();
            sensor1 = 16'hFFFF;
            sensor2 = 16'h0001;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(16'h8000);
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
        input [15:0] expected_estimated_value;
        begin
            if (expected_estimated_value === (expected_estimated_value ^ estimated_value ^ expected_estimated_value)) begin
                $display("PASS");
                $display("  Outputs: estimated_value=%h",
                         estimated_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_value=%h",
                         expected_estimated_value);
                $display("  Got:      estimated_value=%h",
                         estimated_value);
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
        $dumpvars(0,clk, rst, sensor1, sensor2, estimated_value);
    end

endmodule
