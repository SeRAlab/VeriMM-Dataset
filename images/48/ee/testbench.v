`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
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
            $display("\nResetting DUT...");
            reset = 1;
            data_in = 32'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            data_in = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(reference_encrypt(32'h00000000));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones", test_num);
            reset_dut();
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(reference_encrypt(32'hFFFFFFFF));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits A (0xAAAAAAAA)", test_num);
            reset_dut();
            data_in = 32'hAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(reference_encrypt(32'hAAAAAAAA));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits B (0x55555555)", test_num);
            reset_dut();
            data_in = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(reference_encrypt(32'h55555555));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hex Sequence (0x12345678)", test_num);
            reset_dut();
            data_in = 32'h12345678;
            @(posedge clk);
            #2;
            #1;

            check_outputs(reference_encrypt(32'h12345678));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Bit (0x00000001)", test_num);
            reset_dut();
            data_in = 32'h00000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(reference_encrypt(32'h00000001));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Signed Int (0x7FFFFFFF)", test_num);
            reset_dut();
            data_in = 32'h7FFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(reference_encrypt(32'h7FFFFFFF));
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
