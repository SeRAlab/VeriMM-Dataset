`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Data_in;
    reg clk_4f_c;
    reg valid_in;
    wire [7:0] Data_out_c;
    wire valid_out_c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_in(Data_in),
        .clk_4f_c(clk_4f_c),
        .valid_in(valid_in),
        .Data_out_c(Data_out_c),
        .valid_out_c(valid_out_c)
    );

    // Clock generation (10ns period)
    initial begin
        clk_4f_c = 0;
        forever #5 clk_4f_c = ~clk_4f_c;
    end

        task reset_dut;

    begin
        valid_in = 0;
        Data_in = 32'h0;
        @(posedge clk_4f_c);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        Data_in = 32'h12345678;
        valid_in = 1;
        @(posedge clk_4f_c);
        #2;
        #1;

        check_outputs(8'h12, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Data_in = 32'h12345678;
        valid_in = 1;
        repeat(2) @(posedge clk_4f_c);
        #2;
        #1;

        check_outputs(8'h34, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Data_in = 32'h12345678;
        valid_in = 1;
        repeat(4) @(posedge clk_4f_c);
        #2;
        #1;

        check_outputs(8'h78, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Data_in = 32'hAABBCCDD;
        valid_in = 1;
        repeat(5) @(posedge clk_4f_c);
        #2;
        #1;

        check_outputs(8'hAA, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Data_in = 32'hFFFFFFFF;
        valid_in = 1;
        repeat(2) @(posedge clk_4f_c);
        valid_in = 0;
        @(posedge clk_4f_c);
        #2;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        Data_in = 32'h11223344;
        valid_in = 1;
        repeat(2) @(posedge clk_4f_c);
        valid_in = 0;
        @(posedge clk_4f_c);
        valid_in = 1;
        @(posedge clk_4f_c);
        #2;

        #1;


        check_outputs(8'h11, 1'b1);
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
        input [7:0] expected_Data_out_c;
        input expected_valid_out_c;
        begin
            if (expected_Data_out_c === (expected_Data_out_c ^ Data_out_c ^ expected_Data_out_c) &&
                expected_valid_out_c === (expected_valid_out_c ^ valid_out_c ^ expected_valid_out_c)) begin
                $display("PASS");
                $display("  Outputs: Data_out_c=%h, valid_out_c=%b",
                         Data_out_c, valid_out_c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out_c=%h, valid_out_c=%b",
                         expected_Data_out_c, expected_valid_out_c);
                $display("  Got:      Data_out_c=%h, valid_out_c=%b",
                         Data_out_c, valid_out_c);
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
        $dumpvars(0,Data_in, clk_4f_c, valid_in, Data_out_c, valid_out_c);
    end

endmodule
