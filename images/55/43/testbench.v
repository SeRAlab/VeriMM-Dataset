`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] DISPLAY1;
    reg [6:0] DISPLAY2;
    reg [6:0] DISPLAY3;
    reg [6:0] DISPLAY4;
    reg clk;
    wire [3:0] ANODES;
    wire [6:0] DISPLAY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DISPLAY1(DISPLAY1),
        .DISPLAY2(DISPLAY2),
        .DISPLAY3(DISPLAY3),
        .DISPLAY4(DISPLAY4),
        .clk(clk),
        .ANODES(ANODES),
        .DISPLAY(DISPLAY)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DISPLAY1 = 7'h11;
            DISPLAY2 = 7'h22;
            DISPLAY3 = 7'h33;
            DISPLAY4 = 7'h44;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Idle State (Default Pattern)", test_num);
            reset_dut();

            repeat(10) @(posedge clk);

            #1;


            check_outputs(4'b1110, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking Second State (DISPLAY1)", test_num);


            repeat(250) @(posedge clk);

            #1;


            check_outputs(4'b1101, 7'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking Third State (DISPLAY2)", test_num);

            repeat(250) @(posedge clk);

            #1;


            check_outputs(4'b1011, 7'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking Fourth State (DISPLAY3)", test_num);

            repeat(250) @(posedge clk);

            #1;


            check_outputs(4'b0111, 7'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking Wrap-around back to Idle", test_num);

            repeat(250) @(posedge clk);

            #1;


            check_outputs(4'b1110, 7'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Checking display update when input changes", test_num);

            repeat(250) @(posedge clk);

            DISPLAY1 = 7'h55;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'b1101, 7'h55);
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
        input [3:0] expected_ANODES;
        input [6:0] expected_DISPLAY;
        begin
            if (expected_ANODES === (expected_ANODES ^ ANODES ^ expected_ANODES) &&
                expected_DISPLAY === (expected_DISPLAY ^ DISPLAY ^ expected_DISPLAY)) begin
                $display("PASS");
                $display("  Outputs: ANODES=%h, DISPLAY=%h",
                         ANODES, DISPLAY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ANODES=%h, DISPLAY=%h",
                         expected_ANODES, expected_DISPLAY);
                $display("  Got:      ANODES=%h, DISPLAY=%h",
                         ANODES, DISPLAY);
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
        $dumpvars(0,DISPLAY1, DISPLAY2, DISPLAY3, DISPLAY4, clk, ANODES, DISPLAY);
    end

endmodule
