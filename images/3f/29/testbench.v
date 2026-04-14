`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement_x;
    reg [15:0] measurement_y;
    reg reset;
    wire [15:0] estimate_x;
    wire [15:0] estimate_y;
    wire [15:0] velocity_x;
    wire [15:0] velocity_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement_x(measurement_x),
        .measurement_y(measurement_y),
        .reset(reset),
        .estimate_x(estimate_x),
        .estimate_y(estimate_y),
        .velocity_x(velocity_x),
        .velocity_y(velocity_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement_x = 0;
            measurement_y = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Static Object at Origin", test_num);
            reset_dut();

            measurement_x = 16'h0000;
            measurement_y = 16'h0000;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Static Object at Fixed Position", test_num);
            reset_dut();

            measurement_x = 16'h03E8;
            measurement_y = 16'h03E8;


            repeat(20) @(posedge clk);




            #1;





            check_outputs(16'h03E8, 16'h03E8, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Velocity X-Axis", test_num);
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                measurement_x = i * 100;
                measurement_y = 16'h0000;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h0384, 16'h0000, 16'h0064, 16'h0000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Velocity Y-Axis", test_num);
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                measurement_x = 16'h0100;
                measurement_y = i * 50;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h0100, 16'h01C2, 16'h0000, 16'h0032);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal Motion", test_num);
            reset_dut();

            for (i = 0; i < 15; i = i + 1) begin
                measurement_x = i * 20;
                measurement_y = i * 20;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h0118, 16'h0118, 16'h0014, 16'h0014);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Step Response", test_num);
            reset_dut();


            repeat(5) @(posedge clk);


            measurement_x = 16'hFFFF;
            measurement_y = 16'hFFFF;

            @(posedge clk);



            #1;




            check_outputs(16'h7FFF, 16'h7FFF, 16'h7FFF, 16'h7FFF);
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
        input [15:0] expected_estimate_x;
        input [15:0] expected_estimate_y;
        input [15:0] expected_velocity_x;
        input [15:0] expected_velocity_y;
        begin
            if (expected_estimate_x === (expected_estimate_x ^ estimate_x ^ expected_estimate_x) &&
                expected_estimate_y === (expected_estimate_y ^ estimate_y ^ expected_estimate_y) &&
                expected_velocity_x === (expected_velocity_x ^ velocity_x ^ expected_velocity_x) &&
                expected_velocity_y === (expected_velocity_y ^ velocity_y ^ expected_velocity_y)) begin
                $display("PASS");
                $display("  Outputs: estimate_x=%h, estimate_y=%h, velocity_x=%h, velocity_y=%h",
                         estimate_x, estimate_y, velocity_x, velocity_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimate_x=%h, estimate_y=%h, velocity_x=%h, velocity_y=%h",
                         expected_estimate_x, expected_estimate_y, expected_velocity_x, expected_velocity_y);
                $display("  Got:      estimate_x=%h, estimate_y=%h, velocity_x=%h, velocity_y=%h",
                         estimate_x, estimate_y, velocity_x, velocity_y);
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
        $dumpvars(0,clk, measurement_x, measurement_y, reset, estimate_x, estimate_y, velocity_x, velocity_y);
    end

endmodule
