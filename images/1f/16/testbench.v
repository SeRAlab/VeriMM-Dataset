`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] speed_input;
    wire [2:0] speed_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .speed_input(speed_input),
        .speed_output(speed_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            speed_input = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Set speed to level 4");
            test_num = 1;
            reset_dut();
            speed_input = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Set speed to level 7 (Max)");
            test_num = 2;
            reset_dut();
            speed_input = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Set speed to level 0 (Off)");
            test_num = 3;
            reset_dut();
            speed_input = 3'd2;
            @(posedge clk);
            speed_input = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Transition speed from 3 to 6");
            test_num = 4;
            reset_dut();
            speed_input = 3'd3;
            @(posedge clk);
            #1;
            speed_input = 3'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Hold speed level 5 over multiple cycles");
            test_num = 5;
            reset_dut();
            speed_input = 3'd5;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Rapid input changes, check value at clock edge");
            test_num = 6;
            reset_dut();
            speed_input = 3'd1;
            #2 speed_input = 3'd2;
            #2 speed_input = 3'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_controller Testbench");
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
        input [2:0] expected_speed_output;
        begin
            if (expected_speed_output === (expected_speed_output ^ speed_output ^ expected_speed_output)) begin
                $display("PASS");
                $display("  Outputs: speed_output=%h",
                         speed_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speed_output=%h",
                         expected_speed_output);
                $display("  Got:      speed_output=%h",
                         speed_output);
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
        $dumpvars(0,clk, speed_input, speed_output);
    end

endmodule
