`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] _input0;
    reg [31:0] _input1;
    reg [31:0] _input2;
    reg displayWrite;
    wire [6:0] display0;
    wire [6:0] display1;
    wire [6:0] display2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._input0(_input0),
        ._input1(_input1),
        ._input2(_input2),
        .displayWrite(displayWrite),
        .display0(display0),
        .display1(display1),
        .display2(display2)
    );

    // Clock generation (10ns period)
    initial begin
        displayWrite = 0;
        forever #5 displayWrite = ~displayWrite;
    end

        task reset_dut;

        begin
            _input0 = 32'h0;
            _input1 = 32'h0;
            _input2 = 32'h0;

            @(negedge displayWrite);

            @(posedge displayWrite);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: All Zeros");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(7'h00, 7'h00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Basic 7-bit values");
            test_num = 2;
            reset_dut();

            _input0 = 32'h0000_0001;
            _input1 = 32'h0000_002A;
            _input2 = 32'h0000_007F;

            @(posedge displayWrite);
            #1;
            #1;

            check_outputs(7'h01, 7'h2A, 7'h7F);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Truncation of high bits");
            test_num = 3;
            reset_dut();


            _input0 = 32'hFFFF_FF0F;
            _input1 = 32'hABCD_E123;
            _input2 = 32'h1234_5640;

            @(posedge displayWrite);
            #1;
            #1;

            check_outputs(7'h0F, 7'h23, 7'h40);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Sequential updates");
            test_num = 4;
            reset_dut();


            _input0 = 32'h1; _input1 = 32'h2; _input2 = 32'h3;
            @(posedge displayWrite);
            #1;


            _input0 = 32'h4; _input1 = 32'h5; _input2 = 32'h6;
            @(posedge displayWrite);
            #1;
            #1;

            check_outputs(7'h04, 7'h05, 7'h06);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Edge sensitivity check");
            test_num = 5;
            reset_dut();


            _input0 = 32'h10; _input1 = 32'h10; _input2 = 32'h10;
            @(posedge displayWrite);
            #1;


            _input0 = 32'h7F; _input1 = 32'h7F; _input2 = 32'h7F;
            #2;


            #1;



            check_outputs(7'h10, 7'h10, 7'h10);
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
        input [6:0] expected_display0;
        input [6:0] expected_display1;
        input [6:0] expected_display2;
        begin
            if (expected_display0 === (expected_display0 ^ display0 ^ expected_display0) &&
                expected_display1 === (expected_display1 ^ display1 ^ expected_display1) &&
                expected_display2 === (expected_display2 ^ display2 ^ expected_display2)) begin
                $display("PASS");
                $display("  Outputs: display0=%h, display1=%h, display2=%h",
                         display0, display1, display2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display0=%h, display1=%h, display2=%h",
                         expected_display0, expected_display1, expected_display2);
                $display("  Got:      display0=%h, display1=%h, display2=%h",
                         display0, display1, display2);
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
        $dumpvars(0,_input0, _input1, _input2, displayWrite, display0, display1, display2);
    end

endmodule
