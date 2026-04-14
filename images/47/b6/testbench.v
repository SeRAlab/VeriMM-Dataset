`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [7:0] load_val;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_val(load_val),
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
            @(posedge clk);
            reset = 0;
            enable = 0;
            load = 0;
            load_val = 8'h00;
            @(posedge clk);
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Value", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 8'hA5;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Increment", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 8'h10;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Signal Disabled", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 8'h20;
            @(posedge clk);
            load = 0;
            enable = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter Overflow (0xFF -> 0x00)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 8'hFF;
            @(posedge clk);
            load = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Priority over Enable", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 8'hCC;
            enable = 1;
            @(posedge clk);
            load = 0;
            enable = 0;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority over Load", test_num);
            reset_dut();
            @(posedge clk);
            reset = 0;
            load = 1;
            load_val = 8'h55;
            @(posedge clk);
            reset = 1;
            load = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Continuous Increment", test_num);
            reset_dut();
            enable = 1;
            repeat(100) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd100);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, enable, load, load_val, reset, q);
    end

endmodule
