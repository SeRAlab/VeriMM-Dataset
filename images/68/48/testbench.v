`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in = 8'h00;
        repeat(2) @(posedge clk);

        repeat(16) begin
            if (q !== 4'h0) begin
                in[0] = 1; @(posedge clk);
                in[0] = 0; @(posedge clk);
            end
        end
        in = 8'h00;
        @(posedge clk);
        $display("DUT reset sequence completed. Current q: %h", q);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Single falling edge detection", test_num);
        reset_dut();


        in = 8'h01; @(posedge clk);
        in = 8'h00; @(posedge clk);

        repeat(2) @(posedge clk);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Five falling edges", test_num);
        reset_dut();


        repeat(5) begin
            in[0] = 1; @(posedge clk);
            in[0] = 0; @(posedge clk);
        end

        repeat(2) @(posedge clk);
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Ignore rising edges and stable signals", test_num);
        reset_dut();

        in = 8'h00; repeat(2) @(posedge clk);
        in = 8'h01; repeat(2) @(posedge clk);

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Change in[7:1] only", test_num);
        reset_dut();

        in = 8'h00; @(posedge clk);
        in = 8'hFE; @(posedge clk);
        in = 8'h00; @(posedge clk);

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Rollover (15 to 0)", test_num);
        reset_dut();


        repeat(16) begin
            in[0] = 1; @(posedge clk);
            in[0] = 0; @(posedge clk);
        end

        repeat(2) @(posedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: Count up to maximum (15)", test_num);
        reset_dut();

        repeat(15) begin
            in[0] = 1; @(posedge clk);
            in[0] = 0; @(posedge clk);
        end

        repeat(2) @(posedge clk);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, in, q);
    end

endmodule
