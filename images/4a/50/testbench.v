`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [12:0] data;
    reg ena;
    reg load;
    reg reset;
    wire [12:0] q;

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
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            ena = 0;
            data = 0;
            #12;
            reset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic asynchronous reset check", test_num);
            reset_dut();


            #1;



            check_outputs(13'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Load operation", test_num);
            reset_dut();
            @(posedge clk);
            data = 13'h1555;
            load = 1;
            ena = 0;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(13'h1555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit right shift", test_num);
            reset_dut();

            @(posedge clk);
            data = 13'h1FFF;
            load = 1;
            @(posedge clk);

            load = 0;
            ena = 1;
            @(posedge clk);
            #1;
            ena = 0;

            #1;


            check_outputs(13'h0FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple right shifts", test_num);
            reset_dut();
            @(posedge clk);
            data = 13'h1000;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 1;
            repeat (4) @(posedge clk);
            #1;
            ena = 0;

            #1;


            check_outputs(13'h0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load priority over Enable", test_num);
            reset_dut();
            @(posedge clk);
            data = 13'h0AAA;
            load = 1;
            ena = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 0;

            #1;


            check_outputs(13'h0AAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State retention when ena=0 and load=0", test_num);
            reset_dut();
            @(posedge clk);
            data = 13'h0777;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(13'h0777);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shifting out the last bit", test_num);
            reset_dut();
            @(posedge clk);
            data = 13'h0001;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 1;
            @(posedge clk);
            #1;
            ena = 0;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load full scale and shift 12 times", test_num);
            reset_dut();
            @(posedge clk);
            data = 13'h1FFF;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 1;
            repeat (12) @(posedge clk);
            #1;
            ena = 0;

            #1;


            check_outputs(13'h0001);
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
        input [12:0] expected_q;
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
        $dumpvars(0,clk, data, ena, load, reset, q);
    end

endmodule
