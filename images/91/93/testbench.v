`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [7:0] final_output;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .final_output(final_output),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 8'h00;
            @(posedge clk);
            @(negedge clk);
            #1;
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d = 8'h01;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(4) begin
                d = 8'h01;
                @(posedge clk);
                @(negedge clk);
            end


            #1;
            #1;

            check_outputs(8'h08, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d = 8'h01; @(posedge clk); @(negedge clk);
            d = 8'h00; @(posedge clk); @(negedge clk);
            d = 8'h01; @(posedge clk); @(negedge clk);
            d = 8'h01; @(posedge clk); @(negedge clk);

            #1;
            #1;

            check_outputs(8'h0A, 8'h0B);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(8) begin
                d = 8'h01;
                @(posedge clk);
                @(negedge clk);
            end


            #1;
            #1;

            check_outputs(8'h80, 8'hFF);
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
        input [7:0] expected_final_output;
        input [7:0] expected_q;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, q=%h",
                         final_output, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, q=%h",
                         expected_final_output, expected_q);
                $display("  Got:      final_output=%h, q=%h",
                         final_output, q);
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
        $dumpvars(0,clk, d, reset, final_output, q);
    end

endmodule
