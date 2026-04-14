`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pedestrian_button;
    reg reset;
    reg traffic_sensor;
    wire green_light;
    wire pedestrian_light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pedestrian_button(pedestrian_button),
        .reset(reset),
        .traffic_sensor(traffic_sensor),
        .green_light(green_light),
        .pedestrian_light(pedestrian_light)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pedestrian_button = 0;
            traffic_sensor = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State (All Red)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Traffic Sensor -> Green Cars", test_num);
            reset_dut();
            traffic_sensor = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Pedestrian Button -> Green Pedestrian", test_num);
            reset_dut();
            pedestrian_button = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Full Car Cycle (Green -> Yellow -> Red)", test_num);
            reset_dut();
            traffic_sensor = 1;
            @(posedge clk);
            traffic_sensor = 0;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full Pedestrian Cycle (Green -> Red Ped -> Red)", test_num);
            reset_dut();
            pedestrian_button = 1;
            @(posedge clk);
            pedestrian_button = 0;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Pedestrian Button Interruption/Priority", test_num);
            reset_dut();

            traffic_sensor = 1;
            @(posedge clk);

            pedestrian_button = 1;
            traffic_sensor = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous Sensor and Button", test_num);
            reset_dut();
            traffic_sensor = 1;
            pedestrian_button = 1;
            @(posedge clk);
            #2;



            $display("  Checking if system handles simultaneous inputs safely...");
            if (green_light === 1'b1 && pedestrian_light === 1'b1) begin

                fail_count = fail_count + 1;
                $display("FAIL: Safety violation! Both lights green.");
            end else begin
                pass_count = pass_count + 1;
                $display("PASS: System maintained safety (No dual green).");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_green_light;
        input expected_pedestrian_light;
        begin
            if (expected_green_light === (expected_green_light ^ green_light ^ expected_green_light) &&
                expected_pedestrian_light === (expected_pedestrian_light ^ pedestrian_light ^ expected_pedestrian_light)) begin
                $display("PASS");
                $display("  Outputs: green_light=%b, pedestrian_light=%b",
                         green_light, pedestrian_light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green_light=%b, pedestrian_light=%b",
                         expected_green_light, expected_pedestrian_light);
                $display("  Got:      green_light=%b, pedestrian_light=%b",
                         green_light, pedestrian_light);
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
        $dumpvars(0,clk, pedestrian_button, reset, traffic_sensor, green_light, pedestrian_light);
    end

endmodule
