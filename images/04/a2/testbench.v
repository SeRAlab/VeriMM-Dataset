`timescale 1ns/1ps

module noise_suppression_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_signal;
    reg rst;
    reg [7:0] threshold;
    wire [7:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression_filter dut (
        .clk(clk),
        .in_signal(in_signal),
        .rst(rst),
        .threshold(threshold),
        .out_signal(out_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        in_signal = 8'h00;
        threshold = 8'h00;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Pass-through", test_num);
        reset_dut();

        threshold = 8'd50;
        in_signal = 8'd20;
        repeat(5) @(posedge clk);

        in_signal = 8'd30;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive Spike Suppression", test_num);
        reset_dut();

        threshold = 8'd20;
        in_signal = 8'd40;
        repeat(5) @(posedge clk);

        in_signal = 8'd100;
        repeat(5) @(posedge clk);


        #1;



        check_outputs(8'd40);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative Spike Suppression", test_num);
        reset_dut();

        threshold = 8'd15;
        in_signal = 8'd80;
        repeat(5) @(posedge clk);

        in_signal = 8'd20;
        repeat(5) @(posedge clk);


        #1;



        check_outputs(8'd80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Valid Steps", test_num);
        reset_dut();

        threshold = 8'd15;
        in_signal = 8'd10;
        repeat(3) @(posedge clk);
        in_signal = 8'd20;
        repeat(3) @(posedge clk);
        in_signal = 8'd30;
        repeat(3) @(posedge clk);
        in_signal = 8'd40;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'd40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Threshold (All-Pass)", test_num);
        reset_dut();

        threshold = 8'hFF;
        in_signal = 8'd0;
        repeat(3) @(posedge clk);
        in_signal = 8'd255;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Behavior", test_num);
        reset_dut();

        threshold = 8'd100;
        in_signal = 8'd150;
        repeat(5) @(posedge clk);


        rst = 1;
        @(posedge clk);
        rst = 0;
        @(posedge clk);

        #1;


        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression_filter Testbench");
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
        input [7:0] expected_out_signal;
        begin
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
        $dumpvars(0,clk, in_signal, rst, threshold, out_signal);
    end

endmodule
