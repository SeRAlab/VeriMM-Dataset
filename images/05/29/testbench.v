`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] load;
    reg reset;
    wire [1:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .load(load),
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
            load = 4'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Load = 0 (Lower boundary Range 1)");
            reset_dut();
            load = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Load = 3 (Upper boundary Range 1)");
            reset_dut();
            load = 4'd3;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Load = 4 (Lower boundary Range 2)");
            reset_dut();
            load = 4'd4;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Load = 7 (Upper boundary Range 2)");
            reset_dut();
            load = 4'd7;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Load = 8 (Lower boundary Range 3)");
            reset_dut();
            load = 4'd8;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Load = 11 (Upper boundary Range 3)");
            reset_dut();
            load = 4'd11;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Load = 12 (Lower boundary Range 4)");
            reset_dut();
            load = 4'd12;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Load = 15 (Upper boundary Range 4)");
            reset_dut();
            load = 4'd15;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Verify reset resets outputs to 0");
            reset_dut();
            load = 4'd15;
            @(posedge clk);
            #2;
            reset = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_frequency;
        input [1:0] expected_voltage;
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
        $dumpvars(0,clk, load, reset, frequency, voltage);
    end

endmodule
