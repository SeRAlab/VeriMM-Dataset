`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_c;
    reg i1;
    reg [15:0] i10;
    reg i2;
    reg [15:0] i3;
    reg [15:0] i4;
    reg [15:0] i5;
    reg [15:0] i6;
    reg [15:0] i7;
    reg [15:0] i8;
    reg [15:0] i9;
    wire [31:0] o1;
    wire [31:0] o2;
    wire [31:0] o3;
    wire [31:0] o4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_c(clock_c),
        .i1(i1),
        .i10(i10),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .i5(i5),
        .i6(i6),
        .i7(i7),
        .i8(i8),
        .i9(i9),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4)
    );

    // Clock generation (10ns period)
    initial begin
        clock_c = 0;
        forever #5 clock_c = ~clock_c;
    end

        task reset_dut;

        begin
            i1 = 1;
            i2 = 0;
            i3 = 0; i4 = 0; i5 = 0; i6 = 0; i7 = 0; i8 = 0; i9 = 0; i10 = 0;
            @(posedge clock_c);
            #1;
            i1 = 0;
            i2 = 1;
            @(posedge clock_c);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Multiplication", test_num);
            reset_dut();
            i3 = 16'h0002; i4 = 16'h0003;
            i5 = 16'h000A; i6 = 16'h0005;
            i7 = 16'h000C; i8 = 16'h000C;
            i9 = 16'h0001; i10 = 16'h00FF;
            @(posedge clock_c);
            #1;
            #1;

            check_outputs(32'd6, 32'd50, 32'd144, 32'd255);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Multiplication by Zero", test_num);
            reset_dut();
            i3 = 16'hFFFF; i4 = 16'h0000;
            i5 = 16'h0000; i6 = 16'h1234;
            i7 = 16'h0000; i8 = 16'h0000;
            i9 = 16'hABCD; i10 = 16'h0000;
            @(posedge clock_c);
            #1;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Maximum 16-bit Values", test_num);
            reset_dut();
            i3 = 16'hFFFF; i4 = 16'hFFFF;
            i5 = 16'hFFFF; i6 = 16'h0001;
            i7 = 16'h8000; i8 = 16'h0002;
            i9 = 16'hAAAA; i10 = 16'h5555;
            @(posedge clock_c);
            #1;
            #1;

            check_outputs(32'hFFFE0001, 32'h0000FFFF, 32'h00010000, 32'h38E31C72);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Power of 2 (Shifts)", test_num);
            reset_dut();
            i3 = 16'h0001; i4 = 16'h8000;
            i5 = 16'h0100; i6 = 16'h0100;
            i7 = 16'h0002; i8 = 16'h4000;
            i9 = 16'h0010; i10 = 16'h1000;
            @(posedge clock_c);
            #1;
            #1;

            check_outputs(32'h00008000, 32'h00010000, 32'h00008000, 32'h00010000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Random Constants", test_num);
            reset_dut();
            i3 = 16'h1234; i4 = 16'h5678;
            i5 = 16'hFEDC; i6 = 16'hBA98;
            i7 = 16'h4321; i8 = 16'h8765;
            i9 = 16'h1357; i10 = 16'h2468;
            @(posedge clock_c);
            #1;
            #1;

            check_outputs(32'h06260060, 32'hB9C150E0, 32'h236A5505, 32'h02B90DB8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Reset Behavior", test_num);

            reset_dut();
            i3 = 16'hFFFF; i4 = 16'hFFFF;
            @(posedge clock_c);
            #1;

            i1 = 1;
            @(posedge clock_c);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
            i1 = 0;
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
        input [31:0] expected_o1;
        input [31:0] expected_o2;
        input [31:0] expected_o3;
        input [31:0] expected_o4;
        begin
            if (expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4)) begin
                $display("PASS");
                $display("  Outputs: o1=%h, o2=%h, o3=%h, o4=%h",
                         o1, o2, o3, o4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o1=%h, o2=%h, o3=%h, o4=%h",
                         expected_o1, expected_o2, expected_o3, expected_o4);
                $display("  Got:      o1=%h, o2=%h, o3=%h, o4=%h",
                         o1, o2, o3, o4);
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
        $dumpvars(0,clock_c, i1, i10, i2, i3, i4, i5, i6, i7, i8, i9, o1, o2, o3, o4);
    end

endmodule
