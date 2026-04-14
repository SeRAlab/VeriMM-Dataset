`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] error;
    reg reset;
    wire control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .enable(enable),
        .error(error),
        .reset(reset),
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
        enable = 0;
        error = 4'b0000;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Error non-zero, Enable high - Output should settle to 0", test_num);
        reset_dut();

        error = 4'b1010;
        enable = 1;


        repeat(2) @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Different Error value (4'b0111) - Output should settle to 0", test_num);
        reset_dut();

        error = 4'b0111;
        enable = 1;

        repeat(2) @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    reg captured_val;
    begin
        test_num = 3;
        $display("Testcase %0d: Enable low - Controller should hold the current value", test_num);
        reset_dut();


        error = 4'b1111;
        enable = 1;
        @(posedge clk);
        #1 captured_val = control_signal;


        enable = 0;
        error = 4'b0000;

        repeat(2) @(posedge clk);
        #2;


        #1;



        check_outputs(captured_val);
    end
        endtask

    task testcase004;

    reg initial_val;
    begin
        test_num = 4;
        $display("Testcase %0d: Enable low during potential transition", test_num);
        reset_dut();

        #1 initial_val = control_signal;
        enable = 0;
        error = 4'b0011;

        repeat(3) @(posedge clk);
        #2;

        #1;


        check_outputs(initial_val);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Reset override check", test_num);
        reset_dut();

        error = 4'b1100;
        enable = 1;
        @(posedge clk);

        reset = 1;
        @(posedge clk);
        #2;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Sequential error handling", test_num);
        reset_dut();

        enable = 1;
        error = 4'b0001;
        @(posedge clk);
        error = 4'b1000;

        repeat(2) @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0);
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
        input expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%b",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%b",
                         expected_control_signal);
                $display("  Got:      control_signal=%b",
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
        $dumpvars(0,clk, enable, error, reset, control_signal);
    end

endmodule
