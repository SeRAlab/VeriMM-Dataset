`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [7:0] in;
    reg reset;
    wire [3:0] counter_out;
    wire [7:0] edge_out;
    wire [7:0] final_output;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .reset(reset),
        .counter_out(counter_out),
        .edge_out(edge_out),
        .final_output(final_output),
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
        d = 8'h00;
        in = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Register Data Capture", test_num);
        reset_dut();
        d = 8'hA5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h1, 8'h00, 8'h10, 8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Edge Detection on LSB", test_num);
        reset_dut();
        in = 8'h00;
        @(posedge clk);
        #1;
        in = 8'h01;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'h2, 8'h01, 8'h21, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Counter Progression to Preset", test_num);
        reset_dut();

        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(4'h6, 8'h00, 8'h60, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Integration and Wrap-around", test_num);
        reset_dut();
        d = 8'hFF;
        in = 8'h00;
        @(posedge clk);
        #1;
        in = 8'h01;
        repeat(10) @(posedge clk);
        #1;


        #1;



        check_outputs(4'h0, 8'h00, 8'h00, 8'hFF);
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
        input [3:0] expected_counter_out;
        input [7:0] expected_edge_out;
        input [7:0] expected_final_output;
        input [7:0] expected_q;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_edge_out === (expected_edge_out ^ edge_out ^ expected_edge_out) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, edge_out=%h, final_output=%h, q=%h",
                         counter_out, edge_out, final_output, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, edge_out=%h, final_output=%h, q=%h",
                         expected_counter_out, expected_edge_out, expected_final_output, expected_q);
                $display("  Got:      counter_out=%h, edge_out=%h, final_output=%h, q=%h",
                         counter_out, edge_out, final_output, q);
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
        $dumpvars(0,clk, d, in, reset, counter_out, edge_out, final_output, q);
    end

endmodule
