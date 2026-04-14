`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement_position;
    reg [15:0] measurement_velocity;
    reg reset;
    reg [15:0] uncertainty_position;
    reg [15:0] uncertainty_velocity;
    wire [15:0] estimated_position;
    wire [15:0] estimated_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement_position(measurement_position),
        .measurement_velocity(measurement_velocity),
        .reset(reset),
        .uncertainty_position(uncertainty_position),
        .uncertainty_velocity(uncertainty_velocity),
        .estimated_position(estimated_position),
        .estimated_velocity(estimated_velocity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            measurement_position = 16'h0000;
            measurement_velocity = 16'h0000;
            uncertainty_position = 16'h0000;
            uncertainty_velocity = 16'h0000;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Uncertainty (Fast Convergence)", test_num);
            reset_dut();


            measurement_position = 16'h1000;
            measurement_velocity = 16'h0200;
            uncertainty_position = 16'h0001;
            uncertainty_velocity = 16'h0001;


            repeat (10) @(posedge clk);


            #1;



            check_outputs(16'h1000, 16'h0200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Uncertainty (Damping/Slow Response)", test_num);
            reset_dut();

            measurement_position = 16'hFFFF;
            measurement_velocity = 16'hFFFF;
            uncertainty_position = 16'hFFFF;
            uncertainty_velocity = 16'hFFFF;


            repeat (5) @(posedge clk);



            if (estimated_position < 16'h8000 && estimated_velocity < 16'h8000) begin
                $display("PASS: Output damped as expected for high uncertainty.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output changed too quickly despite high uncertainty.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range Stability", test_num);
            reset_dut();

            measurement_position = 16'h8000;
            measurement_velocity = 16'h4000;
            uncertainty_position = 16'h0100;
            uncertainty_velocity = 16'h0100;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(16'h8000, 16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Uncertainty Direct Pass-through", test_num);
            reset_dut();

            measurement_position = 16'hAAAA;
            measurement_velocity = 16'h5555;
            uncertainty_position = 16'h0000;
            uncertainty_velocity = 16'h0000;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA, 16'h5555);
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
        input [15:0] expected_estimated_position;
        input [15:0] expected_estimated_velocity;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position) &&
                expected_estimated_velocity === (expected_estimated_velocity ^ estimated_velocity ^ expected_estimated_velocity)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h, estimated_velocity=%h",
                         estimated_position, estimated_velocity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h, estimated_velocity=%h",
                         expected_estimated_position, expected_estimated_velocity);
                $display("  Got:      estimated_position=%h, estimated_velocity=%h",
                         estimated_position, estimated_velocity);
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
        $dumpvars(0,clk, measurement_position, measurement_velocity, reset, uncertainty_position, uncertainty_velocity, estimated_position, estimated_velocity);
    end

endmodule
