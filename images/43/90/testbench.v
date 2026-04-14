`timescale 1ns/1ps

module geq_8_check_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_num;
    reg clk;
    reg reset;
    wire is_geq_8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    geq_8_check_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .is_geq_8(is_geq_8)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        reset <= 1;
        binary_num <= 4'b0000;
        @(posedge clk);
        reset <= 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Minimum value 0");
        reset_dut();
        binary_num <= 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Boundary value 7");
        reset_dut();
        binary_num <= 4'd7;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Boundary value 8");
        reset_dut();
        binary_num <= 4'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Boundary value 9");
        reset_dut();
        binary_num <= 4'd9;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Maximum value 15");
        reset_dut();
        binary_num <= 4'd15;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Random value 5");
        reset_dut();
        binary_num <= 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Random value 12");
        reset_dut();
        binary_num <= 4'd12;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: Reset state check");
        reset_dut();

        #1;


        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("geq_8_check_module Testbench");
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
        input expected_is_geq_8;
        begin
            if (expected_is_geq_8 === (expected_is_geq_8 ^ is_geq_8 ^ expected_is_geq_8)) begin
                $display("PASS");
                $display("  Outputs: is_geq_8=%b",
                         is_geq_8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_geq_8=%b",
                         expected_is_geq_8);
                $display("  Got:      is_geq_8=%b",
                         is_geq_8);
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
        $dumpvars(0,binary_num, clk, reset, is_geq_8);
    end

endmodule
