`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [511:0] i_data;
    reg i_reset;
    wire [255:0] o_digest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_data(i_data),
        .i_reset(i_reset),
        .o_digest(o_digest)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_reset = 1;
            i_data = 0;
            repeat(5) @(posedge i_clk);
            #1 i_reset = 0;
            repeat(2) @(posedge i_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 'abc' padded", test_num);
            reset_dut();
            i_data = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            repeat(100) @(posedge i_clk);
            #1;

            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty message padded", test_num);
            reset_dut();
            i_data = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            repeat(100) @(posedge i_clk);
            #1;

            check_outputs(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All-zero 512-bit block", test_num);
            reset_dut();
            i_data = 512'h0;
            repeat(100) @(posedge i_clk);
            #1;

            check_outputs(256'hda02ce006509f7a55c2765a08871629858348630018f60161a0d829146f494a8);
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
        input [255:0] expected_o_digest;
        begin
            if (expected_o_digest === (expected_o_digest ^ o_digest ^ expected_o_digest)) begin
                $display("PASS");
                $display("  Outputs: o_digest=%h",
                         o_digest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_digest=%h",
                         expected_o_digest);
                $display("  Got:      o_digest=%h",
                         o_digest);
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
        $dumpvars(0,i_clk, i_data, i_reset, o_digest);
    end

endmodule
