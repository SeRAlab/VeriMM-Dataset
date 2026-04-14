`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg rst;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .rst(rst),
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
            measurement = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Convergence to steady state 0x1000", test_num);
            reset_dut();


            measurement = 16'h1000;
            for (i = 0; i < 50; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(16'h1000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Convergence to steady state 0x7FFF", test_num);
            reset_dut();

            measurement = 16'h7FFF;
            for (i = 0; i < 50; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(16'h7FFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Step response 0x0000 -> 0x4000", test_num);
            reset_dut();


            measurement = 16'h0000;
            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            measurement = 16'h4000;
            for (i = 0; i < 60; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero input stability", test_num);
            reset_dut();

            measurement = 16'h0000;
            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Noisy input filtering (Mean 0x2000)", test_num);
            reset_dut();


            for (i = 0; i < 50; i = i + 1) begin
                if (i % 2 == 0)
                    measurement = 16'h2100;
                else
                    measurement = 16'h1F00;
                @(posedge clk);
                #1;
            end


            measurement = 16'h2000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2000);
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
        $dumpvars(0,clk, measurement, rst, estimate);
    end

endmodule
