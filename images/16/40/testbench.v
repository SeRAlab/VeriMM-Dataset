`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_signal;
    reg reset;
    wire [7:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .input_signal(input_signal),
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
            input_signal = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Single Step Response");
            reset_dut();
            input_signal = 8'h0A;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Multi-cycle Accumulation");
            reset_dut();
            input_signal = 8'h05;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h14);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Zero Input Stability");
            reset_dut();
            input_signal = 8'h10;
            @(posedge clk);
            input_signal = 8'h00;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Boundary Value Test");
            reset_dut();
            input_signal = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_control_output;
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
        $dumpvars(0,clk, input_signal, reset, control_output);
    end

endmodule
