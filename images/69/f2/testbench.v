`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg enable;
    reg reset;
    wire [11:0] out_final;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .reset(reset),
        .out_final(out_final),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset <= 1;
            enable <= 0;
            d <= 8'h00;
            @(posedge clk);
            #1;
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();
            #1;

            check_outputs(12'h340, 8'h34);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Register Load");
            reset_dut();
            @(posedge clk);
            enable <= 0;
            d <= 8'hA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'hA50, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Counter Increment");
            reset_dut();
            @(posedge clk);
            enable <= 1;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(12'h345, 8'h05);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mode Switching");
            reset_dut();

            @(posedge clk);
            enable <= 0;
            d <= 8'h77;
            @(posedge clk);

            enable <= 1;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(12'h773, 8'h03);


            enable <= 0;
            #1;

            #1;


            check_outputs(12'h773, 8'h77);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Counter Overflow");
            reset_dut();
            @(posedge clk);
            enable <= 1;
            repeat (16) @(posedge clk);
            #1;

            #1;


            check_outputs(12'h340, 8'h00);

            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h341, 8'h01);
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
        input [11:0] expected_out_final;
        input [7:0] expected_q;
        begin
            if (expected_out_final === (expected_out_final ^ out_final ^ expected_out_final) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_final=%h, q=%h",
                         out_final, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_final=%h, q=%h",
                         expected_out_final, expected_q);
                $display("  Got:      out_final=%h, q=%h",
                         out_final, q);
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
        $dumpvars(0,clk, d, enable, reset, out_final, q);
    end

endmodule
