`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] ctrl;
    reg [15:0] data;
    reg en;
    wire [6:0] addr;
    wire rs;
    wire rst;
    wire rw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data(data),
        .en(en),
        .addr(addr),
        .rs(rs),
        .rst(rst),
        .rw(rw)
    );

    // Clock generation (10ns period)
    initial begin
        en = 0;
        forever #5 en = ~en;
    end

        task reset_dut;

    begin
        ctrl = 3'b000;
        data = 16'h0000;
        @(posedge en);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: IDLE State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(7'h00, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Send Command (Clear Display)", test_num);
        reset_dut();
        ctrl = 3'b001;
        data = 16'h0001;
        @(posedge en);
        #2;
        #1;

        check_outputs(7'h01, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Set Cursor Position", test_num);
        reset_dut();
        ctrl = 3'b010;
        data = 16'h003F;
        @(posedge en);
        #2;
        #1;

        check_outputs(7'h3F, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Send Data (Character 'A')", test_num);
        reset_dut();
        ctrl = 3'b011;
        data = 16'h0041;
        @(posedge en);
        #2;
        #1;

        check_outputs(7'h41, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Hardware Reset Activation", test_num);
        reset_dut();
        ctrl = 3'b100;
        data = 16'h0000;
        @(posedge en);
        #2;
        #1;

        check_outputs(7'h00, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Transition back to IDLE", test_num);
        reset_dut();
        ctrl = 3'b011;
        @(posedge en);
        #1;
        ctrl = 3'b000;
        repeat(3) @(posedge en);
        #1;
        #1;

        check_outputs(7'h00, 1'b0, 1'b0, 1'b1);
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
        input [6:0] expected_addr;
        input expected_rs;
        input expected_rst;
        input expected_rw;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_rs === (expected_rs ^ rs ^ expected_rs) &&
                expected_rst === (expected_rst ^ rst ^ expected_rst) &&
                expected_rw === (expected_rw ^ rw ^ expected_rw)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, rs=%b, rst=%b, rw=%b",
                         addr, rs, rst, rw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, rs=%b, rst=%b, rw=%b",
                         expected_addr, expected_rs, expected_rst, expected_rw);
                $display("  Got:      addr=%h, rs=%b, rst=%b, rw=%b",
                         addr, rs, rst, rw);
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
        $dumpvars(0,ctrl, data, en, addr, rs, rst, rw);
    end

endmodule
