`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DIN;
    reg DOWN;
    reg LOAD;
    reg UP;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .DOWN(DOWN),
        .LOAD(LOAD),
        .UP(UP),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            LOAD = 1;
            DIN = 4'b0000;
            UP = 0;
            DOWN = 0;
            @(posedge clk);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Load 4'hA", test_num);
            reset_dut();
            @(posedge clk);
            LOAD = 1;
            DIN = 4'hA;
            @(posedge clk);
            LOAD = 0;
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Simple Up Count (0->1)", test_num);
            reset_dut();
            @(posedge clk);
            UP = 1;
            @(posedge clk);
            UP = 0;
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Simple Down Count (5->4)", test_num);
            reset_dut();

            @(posedge clk);
            LOAD = 1;
            DIN = 4'h5;
            @(posedge clk);
            LOAD = 0;
            DOWN = 1;
            @(posedge clk);
            DOWN = 0;
            #1;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Up Count Wrap Around (F->0)", test_num);
            reset_dut();
            @(posedge clk);
            LOAD = 1;
            DIN = 4'hF;
            @(posedge clk);
            LOAD = 0;
            UP = 1;
            @(posedge clk);
            UP = 0;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Down Count Wrap Around (0->F)", test_num);
            reset_dut();
            @(posedge clk);
            DOWN = 1;
            @(posedge clk);
            DOWN = 0;
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Multiple Increments (0->3)", test_num);
            reset_dut();
            @(posedge clk);
            UP = 1;
            repeat (3) @(posedge clk);
            UP = 0;
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: Multiple Decrements (2->F)", test_num);
            reset_dut();
            @(posedge clk);
            LOAD = 1;
            DIN = 4'h2;
            @(posedge clk);
            LOAD = 0;
            DOWN = 1;
            repeat (3) @(posedge clk);
            DOWN = 0;
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %03d: Load Priority Check", test_num);
            reset_dut();
            @(posedge clk);
            LOAD = 1;
            DIN = 4'h5;
            UP = 1;
            DOWN = 1;
            @(posedge clk);
            LOAD = 0;
            UP = 0;
            DOWN = 0;
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %03d: Hold state check", test_num);
            reset_dut();
            @(posedge clk);
            LOAD = 1;
            DIN = 4'h7;
            @(posedge clk);
            LOAD = 0;
            UP = 0;
            DOWN = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %03d: F to 0 then 0 to F", test_num);
            reset_dut();
            @(posedge clk);
            LOAD = 1;
            DIN = 4'hF;
            @(posedge clk);
            LOAD = 0;
            UP = 1;
            @(posedge clk);
            UP = 0;
            DOWN = 1;
            @(posedge clk);
            DOWN = 0;
            #1;
            #1;

            check_outputs(4'hF);
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
        $dumpvars(0,DIN, DOWN, LOAD, UP, clk, Q);
    end

endmodule
