`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg reset;
    reg [4:0] voltage;
    wire frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .enable(enable),
        .reset(reset),
        .voltage(voltage),
        .frequency(frequency)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            reset = 1;
            voltage = 5'b0;
            @(posedge enable);
            #2;
            reset = 0;
            @(posedge enable);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: High Voltage (V=28)", test_num);
            reset_dut();
            voltage = 5'd28;
            @(posedge enable);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Low Voltage (V=8)", test_num);
            reset_dut();
            voltage = 5'd8;
            @(posedge enable);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Maximum Voltage (V=31)", test_num);
            reset_dut();
            voltage = 5'd31;
            @(posedge enable);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Minimum Voltage (V=1)", test_num);
            reset_dut();
            voltage = 5'd1;
            @(posedge enable);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-range Voltage (V=16)", test_num);
            reset_dut();
            voltage = 5'd16;
            @(posedge enable);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input expected_frequency;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency)) begin
                $display("PASS");
                $display("  Outputs: frequency=%b",
                         frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%b",
                         expected_frequency);
                $display("  Got:      frequency=%b",
                         frequency);
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
        $dumpvars(0,enable, reset, voltage, frequency);
    end

endmodule
