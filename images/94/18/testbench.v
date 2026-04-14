`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] voltage;
    wire [3:0] speed;
    wire warning;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .voltage(voltage),
        .speed(speed),
        .warning(warning)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            voltage = 4'd0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Voltage = 0 (Voltage < 4)", test_num);
            voltage = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Voltage = 3 (Voltage < 4)", test_num);
            voltage = 4'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Voltage = 4 (4 <= Voltage < 6)", test_num);
            voltage = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd4, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Voltage = 5 (4 <= Voltage < 6)", test_num);
            voltage = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd4, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Voltage = 6 (6 <= Voltage < 8)", test_num);
            voltage = 4'd6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Voltage = 7 (6 <= Voltage < 8)", test_num);
            voltage = 4'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Voltage = 8 (Voltage >= 8)", test_num);
            voltage = 4'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Voltage = 12 (Voltage >= 8)", test_num);
            voltage = 4'd12;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Voltage = 15 (Voltage >= 8)", test_num);
            voltage = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_speed;
        input expected_warning;
        begin
            if (expected_speed === (expected_speed ^ speed ^ expected_speed) &&
                expected_warning === (expected_warning ^ warning ^ expected_warning)) begin
                $display("PASS");
                $display("  Outputs: speed=%h, warning=%b",
                         speed, warning);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speed=%h, warning=%b",
                         expected_speed, expected_warning);
                $display("  Got:      speed=%h, warning=%b",
                         speed, warning);
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
        $dumpvars(0,clk, voltage, speed, warning);
    end

endmodule
