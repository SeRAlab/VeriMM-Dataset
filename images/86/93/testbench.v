`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg [15:0] root_gen;
    reg [15:0] start_gen;
    wire data_valid;
    wire [7:0] root;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .root_gen(root_gen),
        .start_gen(start_gen),
        .data_valid(data_valid),
        .root(root)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 1;
        start_gen = 16'h0;
        root_gen = 16'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Inactive - Expecting Outputs = 0", test_num);
        reset_dut();

        start_gen = 16'h8000;
        root_gen = 16'hFF00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Active Reset - start_gen[15]=1, Hi > Lo", test_num);
        reset_dut();
        reset_n = 0;
        start_gen = 16'h8000;
        root_gen = 16'h0A05;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Active Reset - start_gen[15]=0, Hi < Lo", test_num);
        reset_dut();
        reset_n = 0;
        start_gen = 16'h7FFF;
        root_gen = 16'h050A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Active Reset - Hi == Lo", test_num);
        reset_dut();
        reset_n = 0;
        start_gen = 16'hFFFF;
        root_gen = 16'h2020;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'h20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Active Reset - Hi=255, Overflow check", test_num);
        reset_dut();
        reset_n = 0;
        start_gen = 16'h8000;
        root_gen = 16'hFF01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Active Reset - Hi=0, Lo=255", test_num);
        reset_dut();
        reset_n = 0;
        start_gen = 16'h0000;
        root_gen = 16'h00FF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'hFF);
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
        input expected_data_valid;
        input [7:0] expected_root;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_root === (expected_root ^ root ^ expected_root)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b, root=%h",
                         data_valid, root);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b, root=%h",
                         expected_data_valid, expected_root);
                $display("  Got:      data_valid=%b, root=%h",
                         data_valid, root);
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
        $dumpvars(0,clk, reset_n, root_gen, start_gen, data_valid, root);
    end

endmodule
