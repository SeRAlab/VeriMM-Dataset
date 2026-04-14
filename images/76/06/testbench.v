`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_val;
    reg reset;
    reg shift;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .reset(reset),
        .shift(shift),
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
        shift = 0;
        load_val = 8'h00;
        @(negedge clk);
        reset = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Asynchronous Reset", test_num);

        load_val = 8'hFF;
        load = 1;
        @(posedge clk);
        #1;
        reset = 1;
        #2;
        #1;

        check_outputs(8'h00);
        reset = 0;
        @(negedge clk);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Parallel Load", test_num);
        reset_dut();
        load = 1;
        load_val = 8'hA5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Single Shift Right", test_num);
        reset_dut();

        load = 1;
        load_val = 8'h80;
        @(posedge clk);
        #1;
        load = 0;
        shift = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h40);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Multiple Shifts Right", test_num);
        reset_dut();
        load = 1;
        load_val = 8'h0F;
        @(posedge clk);
        #1;
        load = 0;
        shift = 1;
        repeat (4) @(posedge clk);
        #2;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Load Priority Check", test_num);
        reset_dut();
        load = 1;
        load_val = 8'h55;
        shift = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Data Hold", test_num);
        reset_dut();
        load = 1;
        load_val = 8'h3C;
        @(posedge clk);
        #1;
        load = 0;
        shift = 0;
        repeat (3) @(posedge clk);
        #2;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Verify MSB fills with 0", test_num);
        reset_dut();
        load = 1;
        load_val = 8'hFF;
        @(posedge clk);
        #1;
        load = 0;
        shift = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h7F);
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
        $dumpvars(0,clk, load, load_val, reset, shift, q);
    end

endmodule
