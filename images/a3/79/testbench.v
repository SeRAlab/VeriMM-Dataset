`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [63:0] srca;
    reg [63:0] srcb;
    wire [63:0] dst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .srca(srca),
        .srcb(srcb),
        .dst(dst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            srca = 64'b0;
            srcb = 64'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            enable = 1;
            srca = 64'h3FF0000000000000;
            srcb = 64'h3FF0000000000000;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h3FF0000000000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            enable = 1;
            srca = 64'h4000000000000000;
            srcb = 64'h4008000000000000;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h4018000000000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            enable = 1;
            srca = 64'hC000000000000000;
            srcb = 64'h4010000000000000;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'hC020000000000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            enable = 1;
            srca = 64'h0000000000000000;
            srcb = 64'h4014000000000000;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            enable = 1;
            srca = 64'h7FF0000000000000;
            srcb = 64'h4000000000000000;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h7FF0000000000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            enable = 1;
            srca = 64'h0000000000000000;
            srcb = 64'h7FF0000000000000;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(64'h7FF8000000000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            enable = 1;
            srca = 64'h7FF8000000000000;
            srcb = 64'h3FF0000000000000;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h7FF8000000000000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            enable = 1;

            srca = 64'h7FEFFFFFFFFFFFFF;
            srcb = 64'h7FEFFFFFFFFFFFFF;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h7FF0000000000000);
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
        testcase008();
        
        
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
        input [63:0] expected_dst;
        begin
            if (expected_dst === (expected_dst ^ dst ^ expected_dst)) begin
                $display("PASS");
                $display("  Outputs: dst=%h",
                         dst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dst=%h",
                         expected_dst);
                $display("  Got:      dst=%h",
                         dst);
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
        $dumpvars(0,clk, enable, srca, srcb, dst);
    end

endmodule
