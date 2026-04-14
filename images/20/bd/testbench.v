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
            test_num = 1;
            $display("Testcase %03d: Constant Input Convergence", test_num);
            reset_dut();
            measurement = 16'd1000;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Step Response", test_num);
            reset_dut();
            measurement = 16'd0;
            repeat(5) @(posedge clk);
            measurement = 16'd5000;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(16'd5000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Noisy Signal", test_num);
            reset_dut();
            repeat(5) begin
                measurement = 16'd2000; @(posedge clk);
                measurement = 16'd2200; @(posedge clk);
                measurement = 16'd1800; @(posedge clk);
                measurement = 16'd2100; @(posedge clk);
                measurement = 16'd1900; @(posedge clk);
            end


            #1;



            check_outputs(16'd2000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Zero Input", test_num);
            reset_dut();
            measurement = 16'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Max Range Test", test_num);
            reset_dut();
            measurement = 16'hFFFF;
            repeat(25) @(posedge clk);
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
        $dumpvars(0,clk, measurement, reset, estimate);
    end

endmodule
