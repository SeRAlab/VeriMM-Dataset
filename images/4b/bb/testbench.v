`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            in = 32'h0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single rising edge detection", test_num);
            reset_dut();
            in = 32'h0; @(posedge clk);
            in = 32'h1; @(posedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple transitions detection", test_num);
            reset_dut();

            in = 32'h0; @(posedge clk);
            in = 32'h1; @(posedge clk);

            in = 32'h0; @(posedge clk);
            in = 32'h1; @(posedge clk);

            in = 32'h0; @(posedge clk);
            in = 32'h1; @(posedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input bits [31:1] transitions", test_num);
            reset_dut();
            in = 32'hFFFFFFFE; @(posedge clk);
            in = 32'h7FFFFFFE; @(posedge clk);
            in = 32'h00000000; @(posedge clk);
            in = 32'hAAAAAAA0; @(posedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sustained high input check", test_num);
            reset_dut();
            in = 32'h0; @(posedge clk);
            in = 32'h1; repeat(5) @(posedge clk);
            in = 32'h0; @(posedge clk);
            in = 32'h1; repeat(5) @(posedge clk);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset mid-counting sequence", test_num);
            reset_dut();

            in = 32'h0; @(posedge clk); in = 32'h1; @(posedge clk);
            in = 32'h0; @(posedge clk); in = 32'h1; @(posedge clk);

            reset = 1; @(posedge clk);
            reset = 0; @(posedge clk);

            in = 32'h0; @(posedge clk);
            in = 32'h1; @(posedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter overflow (16 edges)", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                in = 32'h0; @(posedge clk);
                in = 32'h1; @(posedge clk);
            end
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset while input is high", test_num);
            @(posedge clk);
            in = 32'h1;
            reset = 1;
            @(posedge clk);
            reset = 0;


            @(posedge clk);
            #1;

            check_outputs(4'h1);
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, in, reset, count);
    end

endmodule
