`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_c;
    reg i1;
    reg i2;
    reg [15:0] i3;
    reg [15:0] i4;
    reg [15:0] i5;
    reg [15:0] i6;
    wire [16:0] o1;
    wire [16:0] o2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_c(clock_c),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .i5(i5),
        .i6(i6),
        .o1(o1),
        .o2(o2)
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
            i3 = 0; i4 = 0; i5 = 0; i6 = 0;
            @(posedge clock_c);
            #1;
            i1 = 0;
            @(posedge clock_c);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(17'd0, 17'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            i2 = 1;
            i3 = 16'h000A;
            i4 = 16'h0005;
            i5 = 16'h0014;
            i6 = 16'h001E;
            @(posedge clock_c);
            #1;


            #1;



            check_outputs(17'h000F, 17'h0032);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            i2 = 1;
            i3 = 16'h8000;
            i4 = 16'h8000;
            i5 = 16'hFFFF;
            i6 = 16'h0001;
            @(posedge clock_c);
            #1;
            #1;

            check_outputs(17'h10000, 17'h10000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            i2 = 1;
            i3 = 16'h1111; i4 = 16'h1111;
            i5 = 16'h2222; i6 = 16'h2222;
            @(posedge clock_c);
            #1;

            i2 = 0;
            i3 = 16'hFFFF; i4 = 16'hFFFF;
            @(posedge clock_c);
            #1;

            #1;


            check_outputs(17'h2222, 17'h4444);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            i2 = 1;
            i3 = 16'hFFFF; i4 = 16'hFFFF;
            i5 = 16'hFFFF; i6 = 16'hFFFF;
            @(posedge clock_c);
            #1;
            #1;

            check_outputs(17'h1FFFE, 17'h1FFFE);
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
        input [16:0] expected_o1;
        input [16:0] expected_o2;
        begin
            if (expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2)) begin
                $display("PASS");
                $display("  Outputs: o1=%h, o2=%h",
                         o1, o2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o1=%h, o2=%h",
                         expected_o1, expected_o2);
                $display("  Got:      o1=%h, o2=%h",
                         o1, o2);
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
        $dumpvars(0,clock_c, i1, i2, i3, i4, i5, i6, o1, o2);
    end

endmodule
