`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] position_estimate;

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
        .position_estimate(position_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            measurement = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Static Zero Test", test_num);
            reset_dut();
            control = 16'h0000;
            measurement = 16'h0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Constant Velocity Tracking", test_num);
            reset_dut();

            control = 16'd10;
            measurement = 16'd10; @(posedge clk);
            measurement = 16'd20; @(posedge clk);
            measurement = 16'd30; @(posedge clk);
            measurement = 16'd40; @(posedge clk);
            measurement = 16'd50; @(posedge clk);

            #1;


            check_outputs(16'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Measurement Noise Filtering", test_num);
            reset_dut();
            control = 16'd0;

            repeat(5) begin
                measurement = 16'd90;  @(posedge clk);
                measurement = 16'd110; @(posedge clk);
            end



            #1;




            check_outputs(16'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Step Response (Position Jump)", test_num);
            reset_dut();
            control = 16'd0;
            measurement = 16'd0;
            repeat(2) @(posedge clk);

            measurement = 16'd1000;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Control-Heavy Prediction", test_num);
            reset_dut();
            control = 16'd50;
            measurement = 16'd50;
            @(posedge clk);
            measurement = 16'd100;
            @(posedge clk);


            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'd200);
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
        input [15:0] expected_position_estimate;
        begin
            if (expected_position_estimate === (expected_position_estimate ^ position_estimate ^ expected_position_estimate)) begin
                $display("PASS");
                $display("  Outputs: position_estimate=%h",
                         position_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_estimate=%h",
                         expected_position_estimate);
                $display("  Got:      position_estimate=%h",
                         position_estimate);
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
        $dumpvars(0,clk, control, measurement, reset, position_estimate);
    end

endmodule
