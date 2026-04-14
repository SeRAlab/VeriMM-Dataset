`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire [31:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Enable=0 check...");
            test_num = test_num + 1;
            reset_dut();
            enable = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        reg [31:0] captured_out;
        begin
            $display("Running testcase002: Enable=1 basic check...");
            test_num = test_num + 1;
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            captured_out = out_data;



            if (captured_out != 0 && captured_out[1:0] == 2'b00) begin
                $display("PASS: Output %h is non-zero and a multiple of 4", captured_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output %h is invalid (Expected non-zero multiple of 4)", captured_out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Enable toggle check...");
            test_num = test_num + 1;
            reset_dut();


            enable = 1;
            repeat(3) @(posedge clk);


            #1 enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0);
        end
        endtask

    task testcase004;

        reg [31:0] val1, val2;
        begin
            $display("Running testcase004: State progression check...");
            test_num = test_num + 1;
            reset_dut();

            enable = 1;
            @(posedge clk);
            #1 val1 = out_data;
            @(posedge clk);
            #1 val2 = out_data;


            if (val1 != val2) begin
                $display("PASS: Sequential outputs differ (%h != %h)", val1, val2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Sequential outputs are identical (%h)", val1);
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, enable, rst, out_data);
    end

endmodule
