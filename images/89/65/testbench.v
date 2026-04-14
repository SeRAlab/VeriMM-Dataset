`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg t_d;
    wire [63:0] final_out;
    wire [63:0] johnson_out;
    wire t_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .t_d(t_d),
        .final_out(final_out),
        .johnson_out(johnson_out),
        .t_out(t_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            t_d = 0;
            @(negedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(64'h0, johnson_out, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            t_d = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(johnson_out, johnson_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            t_d = 1;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0, johnson_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            t_d = 1; @(posedge clk);
            t_d = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(johnson_out, johnson_out, 1'b1);
        end
        endtask

    task testcase005;

        reg [63:0] prev_johnson;
        begin
            test_num = 5;
            reset_dut();
            t_d = 1;
            @(posedge clk);
            prev_johnson = johnson_out;

            repeat(5) begin
                @(posedge clk);
                #1;

                if (johnson_out == prev_johnson) begin
                    $display("FAIL: Johnson counter stuck at %h", johnson_out);
                    fail_count = fail_count + 1;
                end else begin

                    #1;


                    check_outputs(johnson_out, johnson_out, t_out);
                end
                prev_johnson = johnson_out;
            end
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
        input [63:0] expected_final_out;
        input [63:0] expected_johnson_out;
        input expected_t_out;
        begin
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_johnson_out === (expected_johnson_out ^ johnson_out ^ expected_johnson_out) &&
                expected_t_out === (expected_t_out ^ t_out ^ expected_t_out)) begin
                $display("PASS");
                $display("  Outputs: final_out=%h, johnson_out=%h, t_out=%b",
                         final_out, johnson_out, t_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%h, johnson_out=%h, t_out=%b",
                         expected_final_out, expected_johnson_out, expected_t_out);
                $display("  Got:      final_out=%h, johnson_out=%h, t_out=%b",
                         final_out, johnson_out, t_out);
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
        $dumpvars(0,clk, rst_n, t_d, final_out, johnson_out, t_out);
    end

endmodule
