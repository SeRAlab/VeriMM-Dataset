`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measured_value;
    reg reset;
    reg [15:0] setpoint;
    wire [15:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .clk(clk),
        .measured_value(measured_value),
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
        measured_value = 16'h0;
        setpoint = 16'h0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Zero Error", test_num);
        reset_dut();
        setpoint = 16'h0064;
        measured_value = 16'h0064;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    reg [15:0] initial_out;
    begin
        test_num = 3;
        $display("Testcase %0d: Integral Accumulation", test_num);
        reset_dut();
        setpoint = 16'h000A;
        measured_value = 16'h0000;

        @(posedge clk);
        #1 initial_out = control_signal;

        repeat(5) @(posedge clk);



        if (control_signal != initial_out && control_signal != 0) begin
            pass_count = pass_count + 1;
            $display("PASS: Output evolved from %h to %h", initial_out, control_signal);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: Output remained static at %h", control_signal);
        end
    end
        endtask

    task testcase004;

    reg [15:0] before_step;
    begin
        test_num = 4;
        $display("Testcase %0d: Derivative Response", test_num);
        reset_dut();
        setpoint = 16'h00FF;
        measured_value = 16'h0000;
        repeat(2) @(posedge clk);
        #1 before_step = control_signal;


        measured_value = 16'h00FE;
        @(posedge clk);
        #1;


        if (control_signal != before_step) begin
            pass_count = pass_count + 1;
            $display("PASS: Derivative action detected. Change: %h -> %h", before_step, control_signal);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: No derivative response detected.");
        end
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Maximum Error Response", test_num);
        reset_dut();
        setpoint = 16'hFFFF;
        measured_value = 16'h0000;
        repeat(1) @(posedge clk);
        #1;

        if (control_signal > 16'h0000) begin
            $display("PASS: Control signal responded to max error: %h", control_signal);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: No response to max error");
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
        $dumpvars(0,clk, measured_value, reset, setpoint, control_signal);
    end

endmodule
