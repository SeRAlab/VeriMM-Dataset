`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg clk;
    reg rst;
    wire [31:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .rst(rst),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            A = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic 10-cycle delay check", test_num);
            reset_dut();


            A = 32'hABCD1234;
            @(negedge clk);


            A = 32'h0;


            repeat(9) @(negedge clk);

            #1;


            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset clearing check", test_num);
            reset_dut();


            A = 32'hFFFFFFFF;
            repeat(5) @(negedge clk);


            rst = 1;
            @(negedge clk);
            rst = 0;



            repeat(10) @(negedge clk);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence propagation check", test_num);
            reset_dut();


            A = 32'd1; @(negedge clk);
            A = 32'd2; @(negedge clk);
            A = 32'd3; @(negedge clk);
            A = 32'd4; @(negedge clk);
            A = 32'd5; @(negedge clk);
            A = 32'd6; @(negedge clk);
            A = 32'd7; @(negedge clk);
            A = 32'd8; @(negedge clk);
            A = 32'd9; @(negedge clk);
            A = 32'd10; @(negedge clk);


            #1;



            check_outputs(32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits toggle (0x55... to 0xAA...)", test_num);
            reset_dut();

            A = 32'h5555_5555;
            @(negedge clk);
            A = 32'hAAAA_AAAA;


            repeat(9) @(negedge clk);
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Latency boundary check (9 cycles)", test_num);
            reset_dut();

            A = 32'hDEADC0DE;
            @(negedge clk);
            A = 0;


            repeat(8) @(negedge clk);


            #1;



            check_outputs(32'h00000000);
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
        input [31:0] expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
        $dumpvars(0,A, clk, rst, X);
    end

endmodule
