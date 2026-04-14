`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_value;
    reg reset;
    reg [3:0] setpoint;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .current_value(current_value),
        .reset(reset),
        .setpoint(setpoint),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_value = 0;
            setpoint = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Upward Step (0 -> 8)");
            reset_dut();
            setpoint = 4'd8;
            current_value = 4'd0;


            repeat(4) begin
                @(posedge clk);
                #1 current_value = current_value + control_signal;
            end


            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Steady State (5 -> 5)");
            reset_dut();
            setpoint = 4'd5;
            current_value = 4'd5;

            repeat(4) begin
                @(posedge clk);
                #1 current_value = current_value + control_signal;
            end

            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Max Range Step (0 -> 15)");
            reset_dut();
            setpoint = 4'd15;
            current_value = 4'd0;

            repeat(4) begin
                @(posedge clk);
                #1 current_value = current_value + control_signal;
            end

            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Downward Step (12 -> 4)");
            reset_dut();
            setpoint = 4'd4;
            current_value = 4'd12;

            repeat(4) begin
                @(posedge clk);
                #1 current_value = current_value + control_signal;
            end

            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
        $dumpvars(0,clk, current_value, reset, setpoint, control_signal);
    end

endmodule
