`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr;
    reg clk;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Pipeline initialized.");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Address 0");
            reset_dut();
            addr = 5'd0;



            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(get_expected_data(5'd0));
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Address 31");
            reset_dut();
            addr = 5'd31;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(get_expected_data(5'd31));
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Sequential Pipelining");
            reset_dut();


            addr = 5'd5;
            @(posedge clk);


            addr = 5'd10;
            @(posedge clk);


            #1;
            if (out === get_expected_data(5'd5)) begin
                $display("  PASS: Pipeline stage 1 correct (out=%h)", out);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Pipeline stage 1 (Expected %h, Got %h)", get_expected_data(5'd5), out);
                fail_count = fail_count + 1;
            end

            @(posedge clk);
            #1;
            if (out === get_expected_data(5'd10)) begin
                $display("  PASS: Pipeline stage 2 correct (out=%h)", out);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Pipeline stage 2 (Expected %h, Got %h)", get_expected_data(5'd10), out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Mid-range Address 15");
            reset_dut();
            addr = 5'd15;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(get_expected_data(5'd15));
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,addr, clk, out);
    end

endmodule
