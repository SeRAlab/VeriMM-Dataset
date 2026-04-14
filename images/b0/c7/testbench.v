`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg DIR;
    reg LOAD;
    reg RESET;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .DIR(DIR),
        .LOAD(LOAD),
        .RESET(RESET),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            LOAD = 0;
            DIR = 0;
            D = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data 4'hA", test_num);
            reset_dut();
            D = 4'hA;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Up Counting 5 times", test_num);
            reset_dut();
            DIR = 1;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Down Counting 3 times from loaded value", test_num);
            reset_dut();

            D = 4'd10;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            DIR = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Up Counting Wrap-around (15->0)", test_num);
            reset_dut();
            D = 4'hF;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            DIR = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Down Counting Wrap-around (0->15)", test_num);
            reset_dut();
            DIR = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Switch DIR (Up 4, Down 2)", test_num);
            reset_dut();
            DIR = 1;
            repeat(4) @(posedge CLK);
            #1;
            DIR = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority over Load", test_num);
            reset_dut();
            D = 4'hC;
            LOAD = 1;
            RESET = 1;
            @(posedge CLK);
            #1;
            RESET = 0;
            LOAD = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Priority over Counting", test_num);
            reset_dut();
            D = 4'h7;
            LOAD = 1;
            DIR = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multi-step Sequence (Load 5, Up 2, Down 4)", test_num);
            reset_dut();
            D = 4'd5;
            LOAD = 1;
            @(posedge CLK); #1;
            LOAD = 0;
            DIR = 1;
            repeat(2) @(posedge CLK); #1;
            DIR = 0;
            repeat(4) @(posedge CLK); #1;

            #1;


            check_outputs(4'd3);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, D, DIR, LOAD, RESET, Q);
    end

endmodule
