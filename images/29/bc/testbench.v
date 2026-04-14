`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] reference;
    reg reset;
    reg [3:0] state;
    wire [3:0] control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .reference(reference),
        .reset(reset),
        .state(state),
        .control(control)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            reference = 0;
            state = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            reference = 4'd10;
            state = 4'd2;
            @(posedge clk);
            #1;
            $display("Test Case 001: Reference=10, State=2");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            reference = 4'd7;
            state = 4'd7;
            @(posedge clk);
            #1;
            $display("Test Case 002: Reference=7, State=7");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            reference = 4'd3;
            state = 4'd8;
            @(posedge clk);
            #1;
            $display("Test Case 003: Reference=3, State=8");

            #1;


            check_outputs(4'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            reference = 4'd15;
            state = 4'd0;
            @(posedge clk);
            #1;
            $display("Test Case 004: Reference=15, State=0");
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            reference = 4'd0;
            state = 4'd1;
            @(posedge clk);
            #1;
            $display("Test Case 005: Reference=0, State=1");

            #1;


            check_outputs(4'd15);
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
        input [3:0] expected_control;
        begin
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%h",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h",
                         expected_control);
                $display("  Got:      control=%h",
                         control);
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
        $dumpvars(0,clk, reference, reset, state, control);
    end

endmodule
