`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg en_write;
    reg reset;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en_write(en_write),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        en_write = 0;
        data_in = 0;
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
        $display("Testcase %03d: Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Basic Write Operation", test_num);
        reset_dut();
        data_in = 32'hA5A5_5A5A;
        en_write = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Write Enable (Disabled) Check", test_num);
        reset_dut();


        data_in = 32'h1234_5678;
        en_write = 1;
        @(posedge clk);
        #1;


        data_in = 32'h8765_4321;
        en_write = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Successive Write Operations", test_num);
        reset_dut();

        en_write = 1;
        data_in = 32'h1111_1111;
        @(posedge clk);
        #1;
        data_in = 32'h2222_2222;
        @(posedge clk);
        #1;
        data_in = 32'h3333_3333;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h3333_3333);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Reset Priority over en_write", test_num);
        reset_dut();


        en_write = 1;
        data_in = 32'hFFFF_FFFF;
        @(posedge clk);
        #1;


        reset = 1;
        data_in = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Boundary Values (Signed Max/Min)", test_num);
        reset_dut();


        en_write = 1;
        data_in = 32'h7FFF_FFFF;
        @(posedge clk);
        #1;


        data_in = 32'h8000_0000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h8000_0000);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, en_write, reset, data_out);
    end

endmodule
