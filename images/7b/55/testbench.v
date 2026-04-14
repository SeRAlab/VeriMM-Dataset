`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [15:0] reg_input;
    reg reg_load;
    wire [15:0] AC_data;
    wire Z_Flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .reg_input(reg_input),
        .reg_load(reg_load),
        .AC_data(AC_data),
        .Z_Flag(Z_Flag)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            @(posedge Clk);
            reg_load = 1;
            reg_input = 16'h0000;
            @(posedge Clk);
            reg_load = 0;
            reg_input = 16'h0000;
            $display("DUT Reset: Loaded 0 into AC_data");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load non-zero value (0xABCD)", test_num);
            reset_dut();

            @(posedge Clk);
            reg_load = 1;
            reg_input = 16'hABCD;

            @(posedge Clk);
            reg_load = 0;
            reg_input = 16'h0000;

            #1;
            #1;

            check_outputs(16'hABCD, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load zero value", test_num);
            reset_dut();

            @(posedge Clk);
            reg_load = 1;
            reg_input = 16'h5555;
            @(posedge Clk);

            reg_input = 16'h0000;
            @(posedge Clk);
            reg_load = 0;

            #1;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify reg_load inhibit", test_num);
            reset_dut();

            @(posedge Clk);
            reg_load = 1;
            reg_input = 16'hAAAA;
            @(posedge Clk);

            reg_load = 0;
            reg_input = 16'hFFFF;
            @(posedge Clk);

            #1;
            #1;

            check_outputs(16'hAAAA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load maximum value (0xFFFF)", test_num);
            reset_dut();

            @(posedge Clk);
            reg_load = 1;
            reg_input = 16'hFFFF;
            @(posedge Clk);
            reg_load = 0;

            #1;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive loads and Z_Flag toggle", test_num);
            reset_dut();

            @(posedge Clk);
            reg_load = 1;
            reg_input = 16'h0000;
            @(posedge Clk);
            reg_input = 16'h0001;
            @(posedge Clk);
            reg_load = 0;

            #1;
            #1;

            check_outputs(16'h0001, 1'b0);
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
        input [15:0] expected_AC_data;
        input expected_Z_Flag;
        begin
            if (expected_AC_data === (expected_AC_data ^ AC_data ^ expected_AC_data) &&
                expected_Z_Flag === (expected_Z_Flag ^ Z_Flag ^ expected_Z_Flag)) begin
                $display("PASS");
                $display("  Outputs: AC_data=%h, Z_Flag=%b",
                         AC_data, Z_Flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AC_data=%h, Z_Flag=%b",
                         expected_AC_data, expected_Z_Flag);
                $display("  Got:      AC_data=%h, Z_Flag=%b",
                         AC_data, Z_Flag);
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
        $dumpvars(0,Clk, reg_input, reg_load, AC_data, Z_Flag);
    end

endmodule
