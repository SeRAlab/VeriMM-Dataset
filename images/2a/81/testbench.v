`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] control_voltage;
    reg [7:0] ref_voltage;
    reg rst;
    wire [7:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .clk(clk),
        .control_voltage(control_voltage),
        .ref_voltage(ref_voltage),
        .rst(rst),
        .output_voltage(output_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control_voltage = 0;
            ref_voltage = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            reset_dut();

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Reference below Control limit");
            reset_dut();
            control_voltage = 8'd150;
            ref_voltage = 8'd50;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Reference above Control limit (Clamping)");
            reset_dut();
            control_voltage = 8'd100;
            ref_voltage = 8'd200;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Reference equals Control limit");
            reset_dut();
            control_voltage = 8'd128;
            ref_voltage = 8'd128;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum input values");
            reset_dut();
            control_voltage = 8'hFF;
            ref_voltage = 8'hFF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Control limit at zero");
            reset_dut();
            control_voltage = 8'd0;
            ref_voltage = 8'd255;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Tracking dynamic reference changes");
            reset_dut();
            control_voltage = 8'd200;
            ref_voltage = 8'd50;
            repeat(2) @(posedge clk);
            ref_voltage = 8'd75;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd75);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Dynamic clamping when control limit drops");
            reset_dut();
            ref_voltage = 8'd150;
            control_voltage = 8'd200;
            repeat(2) @(posedge clk);
            control_voltage = 8'd100;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_output_voltage;
        begin
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
                         output_voltage);
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
        $dumpvars(0,clk, control_voltage, ref_voltage, rst, output_voltage);
    end

endmodule
