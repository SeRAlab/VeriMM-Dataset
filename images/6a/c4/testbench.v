`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] choose;
    reg clk_1m;
    reg [2:0] dir;
    reg [1:0] speed;
    wire [2:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose(choose),
        .clk_1m(clk_1m),
        .dir(dir),
        .speed(speed),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk_1m = 0;
        forever #5 clk_1m = ~clk_1m;
    end

        task reset_dut;

        begin
            dir = 3'b000;
            choose = 2'b00;
            speed = 2'b00;
            @(posedge clk_1m);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            dir = 3'b111;
            choose = 2'b01;
            speed = 2'b00;
            @(posedge clk_1m);
            #1;
            $display("Testcase %0d: Speed=0, State should remain unchanged.", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            speed = 2'b01;
            choose = 2'b00;
            dir = 3'b001;
            @(posedge clk_1m);
            #1;
            $display("Testcase %0d: Mode 0, Dir 1.", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            speed = 2'b10;
            choose = 2'b01;
            dir = 3'b010;
            @(posedge clk_1m);
            #1;
            $display("Testcase %0d: Mode 1, Dir 2.", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            speed = 2'b11;
            choose = 2'b10;
            dir = 3'b100;
            @(posedge clk_1m);
            #1;
            $display("Testcase %0d: Mode 2, Dir 4.", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            speed = 2'b01;
            choose = 2'b11;
            dir = 3'b111;
            @(posedge clk_1m);
            #1;
            $display("Testcase %0d: Undefined inputs, check for default state.", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            speed = 2'b01;
            choose = 2'b00;
            dir = 3'b010;
            @(posedge clk_1m);
            #1;

            speed = 2'b00;
            dir = 3'b111;
            @(posedge clk_1m);
            #1;
            $display("Testcase %0d: Speed drop to 0 mid-operation.", test_num);
            #1;

            check_outputs(3'b010);
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
        input [2:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,choose, clk_1m, dir, speed, state);
    end

endmodule
