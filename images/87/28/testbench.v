`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_data;
    reg in_valid;
    reg out_valid;
    reg reset;
    wire [15:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .out_valid(out_valid),
        .reset(reset),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_valid = 0;
            out_valid = 0;
            in_data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Write and Read", test_num);
            reset_dut();


            in_valid = 1;
            in_data = 16'h1234;
            @(posedge clk);
            in_valid = 0;
            @(posedge clk);


            out_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
            out_valid = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Writes followed by Multiple Reads", test_num);
            reset_dut();


            in_valid = 1;
            in_data = 16'hAAAA; @(posedge clk);
            in_data = 16'hBBBB; @(posedge clk);
            in_data = 16'hCCCC; @(posedge clk);
            in_valid = 0;
            @(posedge clk);


            out_valid = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCCCC);
            out_valid = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interleaved Write and Read", test_num);
            reset_dut();


            in_valid = 1; in_data = 16'h1111; @(posedge clk);
            in_valid = 0; @(posedge clk);


            out_valid = 1; @(posedge clk);
            out_valid = 0; @(posedge clk);


            in_valid = 1; in_data = 16'h2222; @(posedge clk);
            in_valid = 0; @(posedge clk);


            out_valid = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222);
            out_valid = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty Read then Valid Data", test_num);
            reset_dut();


            out_valid = 1;
            @(posedge clk);
            out_valid = 0;
            @(posedge clk);


            in_valid = 1; in_data = 16'hDEAD; @(posedge clk);
            in_valid = 0; @(posedge clk);


            out_valid = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hDEAD);
            out_valid = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Burst Write and Sequential Read", test_num);
            reset_dut();

            in_valid = 1;
            in_data = 16'h0001; @(posedge clk);
            in_data = 16'h0002; @(posedge clk);
            in_data = 16'h0003; @(posedge clk);
            in_data = 16'h0004; @(posedge clk);
            in_data = 16'h0005; @(posedge clk);
            in_valid = 0;
            @(posedge clk);

            out_valid = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0005);
            out_valid = 0;
            @(posedge clk);
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
        input [15:0] expected_out_data;
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
        $dumpvars(0,clk, in_data, in_valid, out_valid, reset, out_data);
    end

endmodule
