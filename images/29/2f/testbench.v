`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] process_variable;
    reg rst;
    reg [15:0] setpoint;
    wire [15:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .clk(clk),
        .process_variable(process_variable),
        .rst(rst),
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
            rst = 1;
            process_variable = 0;
            setpoint = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Error Initial Condition", test_num);
            reset_dut();

            setpoint = 16'h03E8;
            process_variable = 16'h03E8;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Error Step", test_num);
            reset_dut();

            setpoint = 16'h0064;
            process_variable = 16'h0000;

            @(posedge clk);
            #2;



            if (control_signal > 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Positive error produced positive control signal %h", control_signal);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Positive error produced non-positive control signal %h", control_signal);
            end
        end
        endtask

    task testcase003;

        reg [15:0] first_output;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Integral Accumulation", test_num);
            reset_dut();

            setpoint = 16'h0010;
            process_variable = 16'h0000;

            @(posedge clk);
            #2;
            first_output = control_signal;


            repeat(5) @(posedge clk);
            #2;


            if (control_signal > first_output) begin
                $display("PASS: Control signal increased from %h to %h due to integral action", first_output, control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Control signal did not increase. First: %h, Current: %h", first_output, control_signal);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [15:0] prev_output;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Derivative Action", test_num);
            reset_dut();

            setpoint = 16'h0100;
            process_variable = 16'h0050;
            @(posedge clk);
            #2;
            prev_output = control_signal;


            process_variable = 16'h00F0;
            @(posedge clk);
            #2;



            if (control_signal < prev_output) begin
                $display("PASS: Derivative action responded to rapid PV increase. %h -> %h", prev_output, control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Derivative action failed to oppose rapid PV change.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Error Response", test_num);
            reset_dut();

            setpoint = 16'h0010;
            process_variable = 16'h0020;

            @(posedge clk);
            #2;



            if (control_signal > 16'h8000 || control_signal == 16'h0000) begin
                $display("PASS: Negative error handled (Signal: %h)", control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Positive control signal %h produced for negative error", control_signal);
                fail_count = fail_count + 1;
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
        $display("PID_Controller Testbench");
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
        input [15:0] expected_control_signal;
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
        $dumpvars(0,clk, process_variable, rst, setpoint, control_signal);
    end

endmodule
