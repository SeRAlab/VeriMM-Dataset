`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
            load = 1;
            ena = 2'b00;
            data = 100'b0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Load", test_num);
            reset_dut();

            load = 1;
            data = 100'hA5A5A5A5A5A5A5A5A5A5A5A5A;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(100'hA5A5A5A5A5A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Left Rotation Wrap-around", test_num);
            reset_dut();


            load = 1;
            data = 100'h8000000000000000000000000;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(100'h0000000000000000000000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Right Rotation Wrap-around", test_num);
            reset_dut();


            load = 1;
            data = 100'h0000000000000000000000001;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(100'h8000000000000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold State (ena=00)", test_num);
            reset_dut();

            load = 1;
            data = 100'h1234567890ABCDE1234567890;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b00;


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(100'h1234567890ABCDE1234567890);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 100 Left Rotations (Return to Start)", test_num);
            reset_dut();

            load = 1;
            data = 100'hDEADBEEFCAFEDEADBEEFCAFE1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;


            repeat(100) @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(100'hDEADBEEFCAFEDEADBEEFCAFE1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 4 Right Rotations", test_num);
            reset_dut();


            load = 1;
            data = 100'h0000000000000000000000010;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;


            repeat(4) @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(100'h0000000000000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority Over Enable", test_num);
            reset_dut();

            load = 1;
            ena = 2'b01;
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
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
        testcase007();
        
        
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
        input [99:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, ena, load, q);
    end

endmodule
