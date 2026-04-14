`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK_IN;
    reg FRAME_CLOCK;
    reg [9:0] x;
    reg [9:0] y;
    wire [7:0] memRGB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .FRAME_CLOCK(FRAME_CLOCK),
        .x(x),
        .y(y),
        .memRGB(memRGB)
    );
    task pulse_frame;

        begin
            FRAME_CLOCK = 1;
            #10;
            FRAME_CLOCK = 0;
            #10;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Coordinate (0,0)");
        CLK_IN = 0;
        x = 10'd0;
        y = 10'd0;
        pulse_frame();
        @(posedge CLK_IN);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Coordinate (1023, 1023)");
        x = 10'd1023;
        y = 10'd1023;
        pulse_frame();
        @(posedge CLK_IN);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Coordinate (31, 31) - Edge of Block 0");
        x = 10'd31;
        y = 10'd31;
        pulse_frame();
        @(posedge CLK_IN);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Coordinate (128, 0) - Block X index change");
        x = 10'd128;
        y = 10'd0;
        pulse_frame();
        @(posedge CLK_IN);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Coordinate (0, 32) - Block Y index change");
        x = 10'd0;
        y = 10'd32;
        pulse_frame();
        @(posedge CLK_IN);
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Mid-screen (512, 256)");
        x = 10'd512;
        y = 10'd256;
        pulse_frame();
        @(posedge CLK_IN);
        #1;

        check_outputs(8'h44);
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
        input [7:0] expected_memRGB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_memRGB === (expected_memRGB ^ memRGB ^ expected_memRGB)) begin
                $display("PASS");
                $display("  Outputs: memRGB=%h",
                         memRGB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memRGB=%h",
                         expected_memRGB);
                $display("  Got:      memRGB=%h",
                         memRGB);
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
