`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [7:0] data;
    reg enable;
    reg load;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        load = 0;
        enable = 0;
        data = 0;
        #12;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        data <= 8'hA5;
        load <= 1;
        enable <= 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        @(posedge clk);
        data <= 8'h55;
        load <= 1;
        enable <= 1;
        @(posedge clk);

        data <= 8'hFF;
        load <= 0;
        enable <= 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(posedge clk);
        data <= 8'h12;
        load <= 1;
        enable <= 1;
        @(posedge clk);

        data <= 8'h34;
        load <= 1;
        enable <= 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        @(posedge clk);
        data <= 8'hBC;
        load <= 1;
        enable <= 1;
        @(posedge clk);

        data <= 8'h00;
        load <= 0;
        enable <= 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hBC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(posedge clk);
        data <= 8'hEE;
        load <= 1;
        enable <= 1;
        @(posedge clk);
        #1;

        areset = 1;
        #2;
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
        $dumpvars(0,areset, clk, data, enable, load, q);
    end

endmodule
