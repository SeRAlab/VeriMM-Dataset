`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] Blue_in;
    reg [3:0] Green_in;
    reg [3:0] Red_in;
    reg [10:0] pos_x;
    reg [10:0] pos_y;
    reg wr;
    wire [3:0] Blue_out;
    wire [3:0] Green_out;
    wire [3:0] Red_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Blue_in(Blue_in),
        .Green_in(Green_in),
        .Red_in(Red_in),
        .pos_x(pos_x),
        .pos_y(pos_y),
        .wr(wr),
        .Blue_out(Blue_out),
        .Green_out(Green_out),
        .Red_out(Red_out)
    );

    // Clock generation (10ns period)
    initial begin
        wr = 0;
        forever #5 wr = ~wr;
    end

        task reset_dut;

        begin
            pos_x = 11'd0;
            pos_y = 11'd0;
            Red_in = 4'd0;
            Green_in = 4'd0;
            Blue_in = 4'd0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write and Read at (10, 20)...");
            reset_dut();
            test_num = test_num + 1;


            pos_x = 11'd10;
            pos_y = 11'd20;
            Red_in = 4'hA;
            Green_in = 4'hB;
            Blue_in = 4'hC;

            #20;

            #1;


            check_outputs(4'hC, 4'hB, 4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Max Boundary Write and Read (639, 479)...");
            reset_dut();
            test_num = test_num + 1;

            pos_x = 11'd639;
            pos_y = 11'd479;
            Red_in = 4'hF;
            Green_in = 4'h0;
            Blue_in = 4'hF;

            #20;

            #1;


            check_outputs(4'hF, 4'h0, 4'hF);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Origin Write and Read (0, 0)...");
            reset_dut();
            test_num = test_num + 1;

            pos_x = 11'd0;
            pos_y = 11'd0;
            Red_in = 4'h1;
            Green_in = 4'h2;
            Blue_in = 4'h3;

            #20;

            #1;


            check_outputs(4'h3, 4'h2, 4'h1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Overwrite existing pixel at (320, 240)...");
            reset_dut();
            test_num = test_num + 1;

            pos_x = 11'd320;
            pos_y = 11'd240;


            Red_in = 4'h1; Green_in = 4'h1; Blue_in = 4'h1;
            #20;


            Red_in = 4'hE; Green_in = 4'hE; Blue_in = 4'hE;
            #20;

            #1;


            check_outputs(4'hE, 4'hE, 4'hE);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Address Independence Check...");
            reset_dut();
            test_num = test_num + 1;


            pos_x = 11'd100; pos_y = 11'd100;
            Red_in = 4'h5; Green_in = 4'h5; Blue_in = 4'h5;
            #20;


            pos_x = 11'd100; pos_y = 11'd101;
            Red_in = 4'hA; Green_in = 4'hA; Blue_in = 4'hA;
            #20;


            pos_x = 11'd100; pos_y = 11'd100;
            #20;

            #1;


            check_outputs(4'h5, 4'h5, 4'h5);
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
        input [3:0] expected_Blue_out;
        input [3:0] expected_Green_out;
        input [3:0] expected_Red_out;
        begin
            if (expected_Blue_out === (expected_Blue_out ^ Blue_out ^ expected_Blue_out) &&
                expected_Green_out === (expected_Green_out ^ Green_out ^ expected_Green_out) &&
                expected_Red_out === (expected_Red_out ^ Red_out ^ expected_Red_out)) begin
                $display("PASS");
                $display("  Outputs: Blue_out=%h, Green_out=%h, Red_out=%h",
                         Blue_out, Green_out, Red_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Blue_out=%h, Green_out=%h, Red_out=%h",
                         expected_Blue_out, expected_Green_out, expected_Red_out);
                $display("  Got:      Blue_out=%h, Green_out=%h, Red_out=%h",
                         Blue_out, Green_out, Red_out);
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
        $dumpvars(0,Blue_in, Green_in, Red_in, pos_x, pos_y, wr, Blue_out, Green_out, Red_out);
    end

endmodule
