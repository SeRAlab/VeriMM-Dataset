`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] state_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control(control),
        .measurement(measurement),
        .reset(reset),
        .state_estimate(state_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 16'h0;
            measurement = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Control Integration");
            test_num = 2;
            reset_dut();
            control = 16'h0010;
            measurement = 16'h0010;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0010);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Measurement Filtering");
            test_num = 3;
            reset_dut();
            control = 16'h0000;
            measurement = 16'h0064;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0032);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Convergence Test");
            test_num = 4;
            reset_dut();
            control = 16'h0000;
            measurement = 16'h00FF;


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(16'h00FF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Combined Dynamic Test");
            test_num = 5;
            reset_dut();

            control = 16'h0014;
            measurement = 16'h0028;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h001E);
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
        input [15:0] expected_state_estimate;
        begin
            if (expected_state_estimate === (expected_state_estimate ^ state_estimate ^ expected_state_estimate)) begin
                $display("PASS");
                $display("  Outputs: state_estimate=%h",
                         state_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_estimate=%h",
                         expected_state_estimate);
                $display("  Got:      state_estimate=%h",
                         state_estimate);
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
        $dumpvars(0,clk, control, measurement, reset, state_estimate);
    end

endmodule
