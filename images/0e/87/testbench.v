`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] measured_output;
    reg [7:0] ref_input;
    reg rst;
    wire [7:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .measured_output(measured_output),
        .ref_input(ref_input),
        .rst(rst),
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
            ref_input = 8'd0;
            measured_output = 8'd0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Zero Error Regulation");
            reset_dut();
            test_num = 1;
            ref_input = 8'd128;
            measured_output = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Positive Error (Step Up)");
            reset_dut();
            test_num = 2;
            ref_input = 8'd150;
            measured_output = 8'd100;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Negative Error (Step Down)");
            reset_dut();
            test_num = 3;
            ref_input = 8'd50;
            measured_output = 8'd100;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maximum Scale Positive Step");
            reset_dut();
            test_num = 4;
            ref_input = 8'd255;
            measured_output = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum Scale Negative Step");
            reset_dut();
            test_num = 5;
            ref_input = 8'd0;
            measured_output = 8'd255;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Recovery");
            reset_dut();
            test_num = 6;
            ref_input = 8'd200;
            measured_output = 8'd50;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_control_signal;
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
        $dumpvars(0,clk, measured_output, ref_input, rst, control_signal);
    end

endmodule
