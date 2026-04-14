`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] estimate_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .estimate_position(estimate_position)
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Steady State Convergence", test_num);
            reset_dut();
            measurement = 16'h1000;

            repeat (50) @(posedge clk);
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Step Input Response", test_num);
            reset_dut();


            measurement = 16'h2000;
            repeat (50) @(posedge clk);


            measurement = 16'h4000;
            repeat (50) @(posedge clk);

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Ramp Input (Constant Velocity)", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                measurement = i * 16'h0100;
                @(posedge clk);
            end



            #1;




            check_outputs(16'h3F00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Noise Smoothing", test_num);
            reset_dut();


            for (i = 0; i < 50; i = i + 1) begin
                if (i % 2 == 0) measurement = 16'h5010;
                else           measurement = 16'h4FF0;
                @(posedge clk);
            end


            measurement = 16'h5000;
            @(posedge clk);


            #1;



            check_outputs(16'h5000);
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
        input [15:0] expected_estimate_position;
        begin
            if (expected_estimate_position === (expected_estimate_position ^ estimate_position ^ expected_estimate_position)) begin
                $display("PASS");
                $display("  Outputs: estimate_position=%h",
                         estimate_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimate_position=%h",
                         expected_estimate_position);
                $display("  Got:      estimate_position=%h",
                         estimate_position);
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
        $dumpvars(0,clk, measurement, reset, estimate_position);
    end

endmodule
