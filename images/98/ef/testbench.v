`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg addr;
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

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address 0 Selection", test_num);
            reset_dut();

            addr = 1'b0;

            repeat(5) @(posedge clk);
            #1;



            #1;




            check_outputs(out);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address 1 Selection", test_num);
            reset_dut();

            addr = 1'b1;

            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(out);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address Switching Logic", test_num);
            reset_dut();


            addr = 1'b0;
            repeat(2) @(posedge clk);


            addr = 1'b1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Sequential Stability Check", test_num);
            reset_dut();

            addr = 1'b0;
            repeat(20) @(posedge clk);
            #1;

            #1;


            check_outputs(out);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Rapid Toggle Selection", test_num);
            reset_dut();

            addr = 1'b1;
            @(posedge clk);
            addr = 1'b0;
            @(posedge clk);
            addr = 1'b1;
            #1;

            #1;


            check_outputs(out);
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
