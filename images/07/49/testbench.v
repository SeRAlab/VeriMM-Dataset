`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control_signal;
    reg reset;
    wire [3:0] frequency;
    wire [3:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .control_signal(control_signal),
        .reset(reset),
        .frequency(frequency),
        .voltage(voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_signal = 3'b000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset and State 000", test_num);
            reset_dut();
            control_signal = 3'b000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition to State 001", test_num);
            reset_dut();
            control_signal = 3'b001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h2, 4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition to State 010", test_num);
            reset_dut();
            control_signal = 3'b010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h3, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transition to State 011", test_num);
            reset_dut();
            control_signal = 3'b011;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h4, 4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Transition to State 100", test_num);
            reset_dut();
            control_signal = 3'b100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Transition to State 101", test_num);
            reset_dut();
            control_signal = 3'b101;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h6, 4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Transition to State 110", test_num);
            reset_dut();
            control_signal = 3'b110;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h7, 4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Transition to State 111", test_num);
            reset_dut();
            control_signal = 3'b111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h8, 4'h8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Consecutive State Changes", test_num);
            reset_dut();
            control_signal = 3'b010; @(posedge clk);
            control_signal = 3'b111; @(posedge clk);
            #1 #1;
 check_outputs(4'h8, 4'h8);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Reset while in high-performance state", test_num);
            reset_dut();
            control_signal = 3'b111;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        testcase010();
        
        
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
        input [3:0] expected_frequency;
        input [3:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
        $dumpvars(0,clk, control_signal, reset, frequency, voltage);
    end

endmodule
