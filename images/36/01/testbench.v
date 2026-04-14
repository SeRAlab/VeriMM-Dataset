`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] workload;
    wire [3:0] voltage_frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .workload(workload),
        .voltage_frequency(voltage_frequency)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            workload = 2'b00;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Workload 00 (Low)", test_num);
            reset_dut();
            workload = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Workload 01 (Medium)", test_num);
            reset_dut();
            workload = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Workload 10 (High)", test_num);
            reset_dut();
            workload = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Workload 11 (Turbo)", test_num);
            reset_dut();
            workload = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Transition 01 -> 11", test_num);
            reset_dut();


            workload = 2'b01;
            @(posedge clk);


            @(negedge clk);
            workload = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Transition 11 -> 00", test_num);
            reset_dut();


            workload = 2'b11;
            @(posedge clk);


            @(negedge clk);
            workload = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
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
        input [3:0] expected_voltage_frequency;
        begin
            if (expected_voltage_frequency === (expected_voltage_frequency ^ voltage_frequency ^ expected_voltage_frequency)) begin
                $display("PASS");
                $display("  Outputs: voltage_frequency=%h",
                         voltage_frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_frequency=%h",
                         expected_voltage_frequency);
                $display("  Got:      voltage_frequency=%h",
                         voltage_frequency);
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
        $dumpvars(0,clk, reset, workload, voltage_frequency);
    end

endmodule
