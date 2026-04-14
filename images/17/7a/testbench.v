`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_state;
    reg [3:0] reference;
    reg reset;
    wire [3:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .current_state(current_state),
        .reference(reference),
        .reset(reset),
        .control_output(control_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        current_state = 4'd0;
        reference = 4'd0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("testcase001: Positive Transition (Current: 2, Ref: 7)");
        reset_dut();
        current_state = 4'd2;
        reference = 4'd7;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("testcase002: Steady State (Current: 10, Ref: 10)");
        reset_dut();
        current_state = 4'd10;
        reference = 4'd10;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("testcase003: Negative Transition (Current: 8, Ref: 3)");
        reset_dut();
        current_state = 4'd8;
        reference = 4'd3;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("testcase004: Maximum Range (Current: 0, Ref: 15)");
        reset_dut();
        current_state = 4'd0;
        reference = 4'd15;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("testcase005: Reset Priority Check");
        reset = 1;
        current_state = 4'd2;
        reference = 4'd10;
        @(posedge clk);
        #1 #1;
 check_outputs(4'd0);
        reset = 0;
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
        input [3:0] expected_control_output;
        begin
            if (expected_control_output === (expected_control_output ^ control_output ^ expected_control_output)) begin
                $display("PASS");
                $display("  Outputs: control_output=%h",
                         control_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_output=%h",
                         expected_control_output);
                $display("  Got:      control_output=%h",
                         control_output);
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
        $dumpvars(0,clk, current_state, reference, reset, control_output);
    end

endmodule
