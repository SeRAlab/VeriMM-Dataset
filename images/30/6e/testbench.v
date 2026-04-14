`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_state;
    reg [3:0] input_signal;
    reg rst;
    wire [3:0] predicted_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .current_state(current_state),
        .input_signal(input_signal),
        .rst(rst),
        .predicted_state(predicted_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_state = 4'd0;
            input_signal = 4'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            current_state = 4'd5;
            input_signal = 4'd3;
            @(posedge clk);
            #1;
            $write("Test Case 001: current=5, input=3 | Expected=8 | Result: ");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            current_state = 4'd12;
            input_signal = 4'd6;
            @(posedge clk);
            #1;
            $write("Test Case 002: current=12, input=6 | Expected=2 | Result: ");
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            current_state = 4'd0;
            input_signal = 4'd0;
            @(posedge clk);
            #1;
            $write("Test Case 003: current=0, input=0 | Expected=0 | Result: ");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            current_state = 4'd15;
            input_signal = 4'd15;
            @(posedge clk);
            #1;
            $write("Test Case 004: current=15, input=15 | Expected=14 | Result: ");
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            current_state = 4'd8;
            input_signal = 4'd8;
            @(posedge clk);
            #1;
            $write("Test Case 005: current=8, input=8 | Expected=0 | Result: ");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            current_state = 4'd0;
            input_signal = 4'd15;
            @(posedge clk);
            #1;
            $write("Test Case 006: current=0, input=15 | Expected=15 | Result: ");
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
        $display("mpc_controller Testbench");
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
        input [3:0] expected_predicted_state;
        begin
            if (expected_predicted_state === (expected_predicted_state ^ predicted_state ^ expected_predicted_state)) begin
                $display("PASS");
                $display("  Outputs: predicted_state=%h",
                         predicted_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_state=%h",
                         expected_predicted_state);
                $display("  Got:      predicted_state=%h",
                         predicted_state);
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
        $dumpvars(0,clk, current_state, input_signal, rst, predicted_state);
    end

endmodule
