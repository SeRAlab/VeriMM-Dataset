`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aux_reset;
    reg dcm_locked;
    reg debug_sys_rst;
    reg ext_reset;
    reg slowest_clk;
    wire bus_struct_reset;
    wire interconnect_reset;
    wire peripheral_aresetn;
    wire peripheral_reset;
    wire sys_reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aux_reset(aux_reset),
        .dcm_locked(dcm_locked),
        .debug_sys_rst(debug_sys_rst),
        .ext_reset(ext_reset),
        .slowest_clk(slowest_clk),
        .bus_struct_reset(bus_struct_reset),
        .interconnect_reset(interconnect_reset),
        .peripheral_aresetn(peripheral_aresetn),
        .peripheral_reset(peripheral_reset),
        .sys_reset(sys_reset)
    );

    // Clock generation (10ns period)
    initial begin
        slowest_clk = 0;
        forever #5 slowest_clk = ~slowest_clk;
    end

        task reset_dut;

    begin
        ext_reset = 1'b1;
        aux_reset = 1'b0;
        dcm_locked = 1'b0;
        debug_sys_rst = 1'b0;
        repeat(10) @(posedge slowest_clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Initial Power-on (DCM not locked)");
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Normal Operation (DCM Locked, No Reset Inputs)");
        reset_dut();
        ext_reset = 1'b0;
        dcm_locked = 1'b1;

        repeat(50) @(posedge slowest_clk);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: External Reset Trigger Pulse");

        ext_reset = 1'b0;
        dcm_locked = 1'b1;
        repeat(10) @(posedge slowest_clk);


        ext_reset = 1'b1;
        repeat(10) @(posedge slowest_clk);


        ext_reset = 1'b0;
        repeat(50) @(posedge slowest_clk);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Auxiliary Reset Trigger Pulse");

        aux_reset = 1'b0;
        dcm_locked = 1'b1;
        repeat(10) @(posedge slowest_clk);


        aux_reset = 1'b1;
        repeat(10) @(posedge slowest_clk);


        aux_reset = 1'b0;
        repeat(50) @(posedge slowest_clk);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Debug System Reset Trigger Pulse");

        debug_sys_rst = 1'b0;
        dcm_locked = 1'b1;
        repeat(10) @(posedge slowest_clk);


        debug_sys_rst = 1'b1;
        repeat(20) @(posedge slowest_clk);


        debug_sys_rst = 1'b0;
        repeat(50) @(posedge slowest_clk);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input expected_bus_struct_reset;
        input expected_interconnect_reset;
        input expected_peripheral_aresetn;
        input expected_peripheral_reset;
        input expected_sys_reset;
        begin
            if (expected_bus_struct_reset === (expected_bus_struct_reset ^ bus_struct_reset ^ expected_bus_struct_reset) &&
                expected_interconnect_reset === (expected_interconnect_reset ^ interconnect_reset ^ expected_interconnect_reset) &&
                expected_peripheral_aresetn === (expected_peripheral_aresetn ^ peripheral_aresetn ^ expected_peripheral_aresetn) &&
                expected_peripheral_reset === (expected_peripheral_reset ^ peripheral_reset ^ expected_peripheral_reset) &&
                expected_sys_reset === (expected_sys_reset ^ sys_reset ^ expected_sys_reset)) begin
                $display("PASS");
                $display("  Outputs: bus_struct_reset=%b, interconnect_reset=%b, peripheral_aresetn=%b, peripheral_reset=%b, sys_reset=%b",
                         bus_struct_reset, interconnect_reset, peripheral_aresetn, peripheral_reset, sys_reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_struct_reset=%b, interconnect_reset=%b, peripheral_aresetn=%b, peripheral_reset=%b, sys_reset=%b",
                         expected_bus_struct_reset, expected_interconnect_reset, expected_peripheral_aresetn, expected_peripheral_reset, expected_sys_reset);
                $display("  Got:      bus_struct_reset=%b, interconnect_reset=%b, peripheral_aresetn=%b, peripheral_reset=%b, sys_reset=%b",
                         bus_struct_reset, interconnect_reset, peripheral_aresetn, peripheral_reset, sys_reset);
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
        $dumpvars(0,aux_reset, dcm_locked, debug_sys_rst, ext_reset, slowest_clk, bus_struct_reset, interconnect_reset, peripheral_aresetn, peripheral_reset, sys_reset);
    end

endmodule
