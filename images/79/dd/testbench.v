`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] Data;
    reg Up_Down;
    wire [6:0] Resistance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Data(Data),
        .Up_Down(Up_Down),
        .Resistance(Resistance)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        Up_Down = 0;
        Data = 0;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Increment from 50", test_num);
        reset_dut();

        Data = 8'd50;
        Up_Down = 1;


        repeat(10) @(posedge CLK);

        #2;
        #1;

        check_outputs(7'd60);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Decrement from 50", test_num);
        reset_dut();

        Data = 8'd50;
        Up_Down = 0;


        repeat(10) @(posedge CLK);

        #2;
        #1;

        check_outputs(7'd40);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Saturation at Upper Bound (100)", test_num);
        reset_dut();

        Data = 8'd95;
        Up_Down = 1;


        repeat(10) @(posedge CLK);

        #2;
        #1;

        check_outputs(7'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Saturation at Lower Bound (0)", test_num);
        reset_dut();

        Data = 8'd5;
        Up_Down = 0;


        repeat(10) @(posedge CLK);

        #2;
        #1;

        check_outputs(7'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Incrementing while at 100", test_num);
        reset_dut();

        Data = 8'd100;
        Up_Down = 1;

        repeat(5) @(posedge CLK);

        #2;
        #1;

        check_outputs(7'd100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Decrementing while at 0", test_num);
        reset_dut();

        Data = 8'd0;
        Up_Down = 0;

        repeat(5) @(posedge CLK);

        #2;
        #1;

        check_outputs(7'd0);
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
        input [6:0] expected_Resistance;
        begin
            if (expected_Resistance === (expected_Resistance ^ Resistance ^ expected_Resistance)) begin
                $display("PASS");
                $display("  Outputs: Resistance=%h",
                         Resistance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Resistance=%h",
                         expected_Resistance);
                $display("  Got:      Resistance=%h",
                         Resistance);
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
        $dumpvars(0,CLK, Data, Up_Down, Resistance);
    end

endmodule
