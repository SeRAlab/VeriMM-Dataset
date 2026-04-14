`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_state;
    reg [7:0] reference_state;
    reg reset;
    wire [7:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .current_state(current_state),
        .reference_state(reference_state),
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
            current_state = 0;
            reference_state = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            current_state = 8'd100;
            reference_state = 8'd100;
            repeat(5) @(posedge clk);
            $display("Testcase 001: Equilibrium State");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            current_state = 8'd50;
            reference_state = 8'd150;
            repeat(5) @(posedge clk);
            $display("Testcase 002: Positive Error");

            #1;


            check_outputs(8'h64);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            current_state = 8'd200;
            reference_state = 8'd150;
            repeat(5) @(posedge clk);
            $display("Testcase 003: Negative Error");

            #1;


            check_outputs(8'hCE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            current_state = 8'd0;
            reference_state = 8'd255;
            repeat(5) @(posedge clk);
            $display("Testcase 004: Max Positive Saturation");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            reset = 1;
            current_state = 8'd10;
            reference_state = 8'd200;
            repeat(2) @(posedge clk);
            $display("Testcase 005: Reset Persistence Check");
            #1;

            check_outputs(8'h00);
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
        $dumpvars(0,clk, current_state, reference_state, reset, control_output);
    end

endmodule
