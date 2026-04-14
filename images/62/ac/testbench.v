`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg mdio_in_r;
    reg mdio_in_w;
    reg mdio_mdc;
    wire duplex_mode;
    wire [1:0] speed_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mdio_in_r(mdio_in_r),
        .mdio_in_w(mdio_in_w),
        .mdio_mdc(mdio_mdc),
        .duplex_mode(duplex_mode),
        .speed_select(speed_select)
    );

    // Clock generation (10ns period)
    initial begin
        mdio_mdc = 0;
        forever #5 mdio_mdc = ~mdio_mdc;
    end

        task reset_dut;

    begin
        mdio_in_r = 1'b1;
        mdio_in_w = 1'b1;
        repeat(5) @(posedge mdio_mdc);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: 1000 Mbps, Full Duplex", test_num);
        reset_dut();
        send_mdio_frame(16'h0140);
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: 100 Mbps, Half Duplex", test_num);
        reset_dut();
        send_mdio_frame(16'h2000);
        #1;

        check_outputs(1'b0, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: 10 Mbps, Full Duplex", test_num);
        reset_dut();
        send_mdio_frame(16'h0100);
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Reserved Speed, Half Duplex", test_num);
        reset_dut();
        send_mdio_frame(16'h2040);
        #1;

        check_outputs(1'b0, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Back-to-back configuration", test_num);
        reset_dut();
        send_mdio_frame(16'h2140);
        send_mdio_frame(16'h0040);
        #1;

        check_outputs(1'b0, 2'b10);
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
        input expected_duplex_mode;
        input [1:0] expected_speed_select;
        begin
            if (expected_duplex_mode === (expected_duplex_mode ^ duplex_mode ^ expected_duplex_mode) &&
                expected_speed_select === (expected_speed_select ^ speed_select ^ expected_speed_select)) begin
                $display("PASS");
                $display("  Outputs: duplex_mode=%b, speed_select=%h",
                         duplex_mode, speed_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: duplex_mode=%b, speed_select=%h",
                         expected_duplex_mode, expected_speed_select);
                $display("  Got:      duplex_mode=%b, speed_select=%h",
                         duplex_mode, speed_select);
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
        $dumpvars(0,mdio_in_r, mdio_in_w, mdio_mdc, duplex_mode, speed_select);
    end

endmodule
