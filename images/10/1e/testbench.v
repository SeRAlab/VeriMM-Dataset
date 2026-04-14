`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [2:0] speed_control;
    wire [2:0] current_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .reset(reset),
        .speed_control(speed_control),
        .current_speed(current_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            speed_control = 3'b000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            speed_control = 3'd3;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            speed_control = 3'd7;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            speed_control = 3'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            speed_control = 3'd4;

            repeat(15) @(posedge clk);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            speed_control = 3'd1;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            speed_control = 3'd6;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(3'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_control Testbench");
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
        input [2:0] expected_current_speed;
        begin
            if (expected_current_speed === (expected_current_speed ^ current_speed ^ expected_current_speed)) begin
                $display("PASS");
                $display("  Outputs: current_speed=%h",
                         current_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_speed=%h",
                         expected_current_speed);
                $display("  Got:      current_speed=%h",
                         current_speed);
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
        $dumpvars(0,clk, reset, speed_control, current_speed);
    end

endmodule
