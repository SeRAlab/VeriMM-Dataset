`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg add1;
    reg [12:0] init_val;
    reg rst;
    reg sck;
    wire [12:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add1(add1),
        .init_val(init_val),
        .rst(rst),
        .sck(sck),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        sck = 0;
        forever #5 sck = ~sck;
    end

        task reset_dut;

        begin
            rst = 1;
            add1 = 0;
            init_val = 13'h0000;
            @(negedge sck);
            rst = 0;
            @(negedge sck);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Initial Value after Reset", test_num);
            init_val = 13'h1A2B;
            rst = 1;
            @(negedge sck);
            rst = 0;
            add1 = 0;
            @(negedge sck);
            #1;

            check_outputs(13'h1A2B);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment counter 10 times", test_num);
            init_val = 13'h0000;
            rst = 1;
            @(negedge sck);
            rst = 0;
            add1 = 1;
            repeat(10) @(negedge sck);
            add1 = 0;
            #1;

            check_outputs(13'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Hold Logic (add1=0)", test_num);
            init_val = 13'h0500;
            rst = 1;
            @(negedge sck);
            rst = 0;
            add1 = 1;
            repeat(5) @(negedge sck);
            add1 = 0;
            repeat(10) @(negedge sck);
            #1;

            check_outputs(13'h0505);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow/Wrap-around Test", test_num);
            init_val = 13'h1FFE;
            rst = 1;
            @(negedge sck);
            rst = 0;
            add1 = 1;
            @(negedge sck);
            @(negedge sck);
            @(negedge sck);
            add1 = 0;
            #1;

            check_outputs(13'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermittent Incrementing", test_num);
            init_val = 13'h0000;
            rst = 1;
            @(negedge sck);
            rst = 0;


            add1 = 1; @(negedge sck);

            add1 = 0; @(negedge sck);

            add1 = 1; @(negedge sck);

            add1 = 0; @(negedge sck);

            add1 = 1; @(negedge sck);

            #1;


            check_outputs(13'h0003);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            init_val = 13'h0100;
            rst = 1;
            @(negedge sck);
            rst = 0;
            add1 = 1;
            repeat(20) @(negedge sck);


            init_val = 13'h0ABC;
            rst = 1;
            @(negedge sck);
            rst = 0;
            add1 = 0;
            @(negedge sck);

            #1;


            check_outputs(13'h0ABC);
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
        input [12:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,add1, init_val, rst, sck, count);
    end

endmodule
