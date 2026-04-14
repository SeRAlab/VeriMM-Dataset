`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] hd_data_from_host;
    reg hd_read_from_host;
    reg rst;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .hd_data_from_host(hd_data_from_host),
        .hd_read_from_host(hd_read_from_host),
        .rst(rst),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            hd_read_from_host = 0;
            hd_data_from_host = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Sequential Matching Data", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;


            repeat(4) begin
                @(negedge clk);
                hd_read_from_host = 1;
                hd_data_from_host = test_num - 1;
                test_num = test_num + 1;
            end

            @(negedge clk);
            hd_read_from_host = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Error Detection on Mismatch", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;

            @(negedge clk);
            hd_read_from_host = 1;
            hd_data_from_host = 32'hFFFF_FFFF;

            @(negedge clk);
            hd_read_from_host = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Enable Transition (L->H) Resets Counter", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            @(negedge clk);
            hd_read_from_host = 1; hd_data_from_host = 0;
            @(negedge clk);
            hd_read_from_host = 1; hd_data_from_host = 1;


            @(negedge clk);
            enable = 0;
            hd_read_from_host = 0;
            @(negedge clk);
            enable = 1;


            @(negedge clk);
            hd_read_from_host = 1; hd_data_from_host = 0;

            @(negedge clk);
            hd_read_from_host = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Gated Read (hd_read_from_host)", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;


            @(negedge clk);
            hd_read_from_host = 1; hd_data_from_host = 0;


            @(negedge clk);
            hd_read_from_host = 0; hd_data_from_host = 32'hDEAD_BEEF;


            @(negedge clk);
            hd_read_from_host = 1; hd_data_from_host = 1;

            @(negedge clk);
            hd_read_from_host = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Reset Clears Error State", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            @(negedge clk);
            hd_read_from_host = 1; hd_data_from_host = 32'h1234;

            @(negedge clk);

            if (error !== 1'b1) $display("  Note: Error signal didn't assert as expected before reset.");


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
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
        input expected_error;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: error=%b",
                         error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b",
                         expected_error);
                $display("  Got:      error=%b",
                         error);
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
        $dumpvars(0,clk, enable, hd_data_from_host, hd_read_from_host, rst, error);
    end

endmodule
