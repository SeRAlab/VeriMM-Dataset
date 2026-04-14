`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] state;
    wire [3:0] control_action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .reset(reset),
        .state(state),
        .control_action(control_action)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        state = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: State = 0");
        reset_dut();
        state = 4'd0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd1);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: State = 5");
        reset_dut();
        state = 4'd5;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: State = 8 (Threshold Boundary)");
        reset_dut();
        state = 4'd8;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd9);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: State = 9 (Above Threshold)");
        reset_dut();
        state = 4'd9;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: State = 15");
        reset_dut();
        state = 4'd15;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Reset behavior check");
        reset_dut();

        state = 4'd0;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd1);
    end
        endtask

    task testcase007;

    begin
        $display("Running Testcase 007: Transition 8 -> 9");
        reset_dut();
        state = 4'd8;
        @(posedge clk);
        state = 4'd9;
        @(posedge clk);
        #1 #1;
 check_outputs(4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [3:0] expected_control_action;
        begin
            if (expected_control_action === (expected_control_action ^ control_action ^ expected_control_action)) begin
                $display("PASS");
                $display("  Outputs: control_action=%h",
                         control_action);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_action=%h",
                         expected_control_action);
                $display("  Got:      control_action=%h",
                         control_action);
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
        $dumpvars(0,clk, reset, state, control_action);
    end

endmodule
