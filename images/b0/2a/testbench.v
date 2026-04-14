`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg incr;
    reg rst;
    reg we;
    reg [15:0] wr;
    wire [12:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .incr(incr),
        .rst(rst),
        .we(we),
        .wr(wr),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            incr = 0;
            wr = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(13'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write", test_num);
            reset_dut();
            we = 1;
            wr = 16'h0ABC;
            @(posedge clk);
            #1 we = 0;
            #1;

            check_outputs(13'h0ABC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment from Zero", test_num);
            reset_dut();
            incr = 1;
            @(posedge clk);
            #1 incr = 0;
            #1;

            check_outputs(13'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write then Increment", test_num);
            reset_dut();

            we = 1;
            wr = 16'h0100;
            @(posedge clk);

            we = 0;
            incr = 1;
            @(posedge clk);
            #1 incr = 0;
            #1;

            check_outputs(13'h0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Increments", test_num);
            reset_dut();
            incr = 1;
            repeat(10) @(posedge clk);
            #1 incr = 0;
            #1;

            check_outputs(13'h000A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Output Truncation Check", test_num);
            reset_dut();
            we = 1;
            wr = 16'hFFFF;
            @(posedge clk);
            #1 we = 0;

            #1;


            check_outputs(13'h1FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 13-bit Boundary Rollover", test_num);
            reset_dut();
            we = 1;
            wr = 16'h1FFF;
            @(posedge clk);
            we = 0;
            incr = 1;
            @(posedge clk);
            #1 incr = 0;

            #1;


            check_outputs(13'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Priority over Increment", test_num);
            reset_dut();
            we = 1;
            wr = 16'h0555;
            incr = 1;
            @(posedge clk);
            #1 we = 0; incr = 0;

            #1;


            check_outputs(13'h0555);
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
        input [12:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,clk, incr, rst, we, wr, rd);
    end

endmodule
