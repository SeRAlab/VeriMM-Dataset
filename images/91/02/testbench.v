`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg clr;
    reg [15:0] input_port;
    wire [15:0] output_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .input_port(input_port),
        .output_port(output_port)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            clr = 1;
            ce = 0;
            input_port = 16'h0000;
            @(negedge clk);
            clr = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Clear Priority", test_num);
            reset_dut();

            @(negedge clk);
            input_port = 16'hAAAA;
            ce = 1;
            clr = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Data Pass-Through", test_num);
            reset_dut();

            @(negedge clk);
            input_port = 16'h1234;
            ce = 1;
            clr = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Retention (ce=0)", test_num);
            reset_dut();


            @(negedge clk);
            input_port = 16'h5555;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;


            @(negedge clk);
            input_port = 16'hFFFF;
            ce = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Clear when ce is 0", test_num);
            reset_dut();


            @(negedge clk);
            input_port = 16'hBEEF;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;


            @(negedge clk);
            ce = 0;
            clr = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Transfers", test_num);
            reset_dut();

            @(negedge clk);
            input_port = 16'h1111;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;

            @(negedge clk);
            input_port = 16'h2222;
            @(posedge clk);
            #1;

            @(negedge clk);
            input_port = 16'h3333;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-Ones Boundary Transfer", test_num);
            reset_dut();

            @(negedge clk);
            input_port = 16'hFFFF;
            ce = 1;
            clr = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Retention after Input Change", test_num);
            reset_dut();


            @(negedge clk);
            input_port = 16'hABCD;
            ce = 1;
            @(posedge clk);
            #1;


            @(negedge clk);
            ce = 0;
            input_port = 16'h1111;
            @(posedge clk);
            @(negedge clk);
            input_port = 16'h2222;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hABCD);
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
        input [15:0] expected_output_port;
        begin
            if (expected_output_port === (expected_output_port ^ output_port ^ expected_output_port)) begin
                $display("PASS");
                $display("  Outputs: output_port=%h",
                         output_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_port=%h",
                         expected_output_port);
                $display("  Got:      output_port=%h",
                         output_port);
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
        $dumpvars(0,ce, clk, clr, input_port, output_port);
    end

endmodule
