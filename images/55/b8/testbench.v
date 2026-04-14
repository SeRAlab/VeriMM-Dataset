`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
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
        .enable(enable),
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
        data_in = 32'b0;
        enable = 0;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verification of the Asynchronous Reset", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Capture data with Enable High", test_num);
        reset_dut();

        data_in = 32'hABCDE123;
        enable = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hABCDE123);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Data Gating with Enable Low", test_num);
        reset_dut();


        data_in = 32'hFFFFFFFF;
        enable = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Hold value when Enable transitions to Low", test_num);
        reset_dut();


        data_in = 32'h5555AAAA;
        enable = 1;
        @(posedge clk);
        #2;


        enable = 0;
        data_in = 32'h00000000;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h5555AAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Asynchronous Reset mid-cycle", test_num);
        reset_dut();


        data_in = 32'h12345678;
        enable = 1;
        @(posedge clk);
        #2;


        #3;
        reset = 1;
        #1;
        #1;

        check_outputs(32'h00000000);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple consecutive updates", test_num);
        reset_dut();

        enable = 1;
        data_in = 32'h1;
        @(posedge clk);
        #2;
        data_in = 32'h2;
        @(posedge clk);
        #2;
        data_in = 32'h3;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Max Value", test_num);
        reset_dut();

        enable = 1;
        data_in = 32'hFFFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF);
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
        $dumpvars(0,clk, data_in, enable, reset, data_out);
    end

endmodule
