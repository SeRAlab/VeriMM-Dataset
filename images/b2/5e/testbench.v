`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aux_reset_in;
    reg dcm_locked;
    reg ext_reset_in;
    reg mb_debug_sys_rst;
    reg slowest_sync_clk;
    wire bus_struct_reset;
    wire interconnect_aresetn;
    wire mb_reset;
    wire peripheral_aresetn;
    wire peripheral_reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aux_reset_in(aux_reset_in),
        .dcm_locked(dcm_locked),
        .ext_reset_in(ext_reset_in),
        .mb_debug_sys_rst(mb_debug_sys_rst),
        .slowest_sync_clk(slowest_sync_clk),
        .bus_struct_reset(bus_struct_reset),
        .interconnect_aresetn(interconnect_aresetn),
        .mb_reset(mb_reset),
        .peripheral_aresetn(peripheral_aresetn),
        .peripheral_reset(peripheral_reset)
    );
    task testcase001;

    begin
        test_num = 1;
        ext_reset_in = 0;
        aux_reset_in = 0;
        mb_debug_sys_rst = 0;
        dcm_locked = 0;
        repeat(10) @(posedge slowest_sync_clk);

        #1;


        check_outputs(1, 0, 1, 0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        dcm_locked = 0;
        repeat(5) @(posedge slowest_sync_clk);

        dcm_locked = 1;
        ext_reset_in = 0;
        aux_reset_in = 0;
        mb_debug_sys_rst = 0;

        repeat(64) @(posedge slowest_sync_clk);

        #1;


        check_outputs(0, 1, 0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        dcm_locked = 1;
        ext_reset_in = 0;
        repeat(10) @(posedge slowest_sync_clk);

        ext_reset_in = 1;
        repeat(10) @(posedge slowest_sync_clk);

        #1;


        check_outputs(1, 0, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        ext_reset_in = 0;
        dcm_locked = 1;
        repeat(64) @(posedge slowest_sync_clk);

        aux_reset_in = 1;
        repeat(10) @(posedge slowest_sync_clk);

        #1;


        check_outputs(1, 0, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        aux_reset_in = 0;
        dcm_locked = 1;
        repeat(64) @(posedge slowest_sync_clk);

        mb_debug_sys_rst = 1;
        repeat(10) @(posedge slowest_sync_clk);

        #1;


        check_outputs(1, 0, 1, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        mb_debug_sys_rst = 0;
        dcm_locked = 1;
        repeat(64) @(posedge slowest_sync_clk);

        dcm_locked = 0;
        repeat(10) @(posedge slowest_sync_clk);

        #1;


        check_outputs(1, 0, 1, 0, 1);
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
        input expected_interconnect_aresetn;
        input expected_mb_reset;
        input expected_peripheral_aresetn;
        input expected_peripheral_reset;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus_struct_reset === (expected_bus_struct_reset ^ bus_struct_reset ^ expected_bus_struct_reset) &&
                expected_interconnect_aresetn === (expected_interconnect_aresetn ^ interconnect_aresetn ^ expected_interconnect_aresetn) &&
                expected_mb_reset === (expected_mb_reset ^ mb_reset ^ expected_mb_reset) &&
                expected_peripheral_aresetn === (expected_peripheral_aresetn ^ peripheral_aresetn ^ expected_peripheral_aresetn) &&
                expected_peripheral_reset === (expected_peripheral_reset ^ peripheral_reset ^ expected_peripheral_reset)) begin
                $display("PASS");
                $display("  Outputs: bus_struct_reset=%b, interconnect_aresetn=%b, mb_reset=%b, peripheral_aresetn=%b, peripheral_reset=%b",
                         bus_struct_reset, interconnect_aresetn, mb_reset, peripheral_aresetn, peripheral_reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_struct_reset=%b, interconnect_aresetn=%b, mb_reset=%b, peripheral_aresetn=%b, peripheral_reset=%b",
                         expected_bus_struct_reset, expected_interconnect_aresetn, expected_mb_reset, expected_peripheral_aresetn, expected_peripheral_reset);
                $display("  Got:      bus_struct_reset=%b, interconnect_aresetn=%b, mb_reset=%b, peripheral_aresetn=%b, peripheral_reset=%b",
                         bus_struct_reset, interconnect_aresetn, mb_reset, peripheral_aresetn, peripheral_reset);
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

endmodule
