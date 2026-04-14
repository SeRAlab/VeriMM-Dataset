`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [60:0] data_in;
    wire [5:0] lz_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .lz_pos(lz_pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 61'h1FFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 61'h0FFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 61'h17FFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd59);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 61'h1BFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd58);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 61'h1FFFFFFFFFFFFFFE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 61'h1FFFFFFFFFFFFFFD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            data_in = 61'h1FFFFFFF7FFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            data_in = 61'h1FFFFFFF BFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd30);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data_in = 61'h0000000000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd60);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();


            data_in = 61'h1FFF BFFFFFFFFFE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd45);
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
        testcase009();
        
        
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
        input [5:0] expected_lz_pos;
        begin
            if (expected_lz_pos === (expected_lz_pos ^ lz_pos ^ expected_lz_pos)) begin
                $display("PASS");
                $display("  Outputs: lz_pos=%h",
                         lz_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lz_pos=%h",
                         expected_lz_pos);
                $display("  Got:      lz_pos=%h",
                         lz_pos);
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
        $dumpvars(0,clk, data_in, lz_pos);
    end

endmodule
