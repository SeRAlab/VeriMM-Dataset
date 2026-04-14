`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pedestrian_button;
    reg reset;
    wire pedestrian_light;
    wire traffic_light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pedestrian_button(pedestrian_button),
        .reset(reset),
        .pedestrian_light(pedestrian_light),
        .traffic_light(traffic_light)
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
        @(posedge clk);
        #2 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset State (RED)", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State Transition RED -> GREEN", test_num);
        reset_dut();
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State Transition GREEN -> YELLOW", test_num);
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State Transition YELLOW -> RED", test_num);
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pedestrian Button Triggered (RED -> YELLOW)", test_num);
        reset_dut();

        pedestrian_button = 1;
        @(posedge clk);
        #2;
        pedestrian_button = 0;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pedestrian Button Triggered (GREEN -> YELLOW)", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        pedestrian_button = 1;
        @(posedge clk);
        #2;
        pedestrian_button = 0;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-operation Reset", test_num);
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        #2;
        reset = 0;

        #1;


        check_outputs(1'b0, 1'b1);
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
        input expected_pedestrian_light;
        input expected_traffic_light;
        begin
            if (expected_pedestrian_light === (expected_pedestrian_light ^ pedestrian_light ^ expected_pedestrian_light) &&
                expected_traffic_light === (expected_traffic_light ^ traffic_light ^ expected_traffic_light)) begin
                $display("PASS");
                $display("  Outputs: pedestrian_light=%b, traffic_light=%b",
                         pedestrian_light, traffic_light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pedestrian_light=%b, traffic_light=%b",
                         expected_pedestrian_light, expected_traffic_light);
                $display("  Got:      pedestrian_light=%b, traffic_light=%b",
                         pedestrian_light, traffic_light);
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
        $dumpvars(0,clk, pedestrian_button, reset, pedestrian_light, traffic_light);
    end

endmodule
