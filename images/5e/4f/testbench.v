`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [31:0] in_vec;
    reg reset;
    wire [31:0] out_vec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .in_vec(in_vec),
        .reset(reset),
        .out_vec(out_vec)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_vec = 0;
            control = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Swap Mode");
            reset_dut();
            test_num = test_num + 1;
            in_vec = 32'h12345678;
            control = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h56781234);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Pass-through Mode");
            reset_dut();
            test_num = test_num + 1;
            in_vec = 32'h87654321;
            control = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Reset during operation");
            reset_dut();
            test_num = test_num + 1;
            in_vec = 32'hFFFFFFFF;
            control = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Pattern Swap (AAAA/5555)");
            reset_dut();
            test_num = test_num + 1;
            in_vec = 32'hAAAA5555;
            control = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: All zeros vector");
            reset_dut();
            test_num = test_num + 1;
            in_vec = 32'h00000000;
            control = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Half-filled vector swap");
            reset_dut();
            test_num = test_num + 1;
            in_vec = 32'h0000FFFF;
            control = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Dynamic data change");
            reset_dut();
            test_num = test_num + 1;


            in_vec = 32'hDEADBEEF;
            control = 1;
            @(posedge clk);


            in_vec = 32'hCAFEFEED;
            control = 0;
            #1;
            #1;

            check_outputs(32'hBEEFDEAD);
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
        input [31:0] expected_out_vec;
        begin
            if (expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec)) begin
                $display("PASS");
                $display("  Outputs: out_vec=%h",
                         out_vec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_vec=%h",
                         expected_out_vec);
                $display("  Got:      out_vec=%h",
                         out_vec);
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
        $dumpvars(0,clk, control, in_vec, reset, out_vec);
    end

endmodule
