`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d1;
    reg [7:0] d2;
    reg select;
    wire error_flag;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .select(select),
        .error_flag(error_flag),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d1 = 0;
            d2 = 0;
            select = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DFF Mode - Load 0xA5", test_num);
            reset_dut();

            d1 = 8'hA5;
            d2 = 8'h00;
            select = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: SR Mode - Shift in 1", test_num);
            reset_dut();

            d1 = 8'h00;
            d2 = 8'h01;
            select = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: SR Mode - Multi-step Shift (1 then 1)", test_num);
            reset_dut();


            d1 = 8'h00; d2 = 8'h01; select = 1;
            @(posedge clk);


            d1 = 8'h00; d2 = 8'h01; select = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parity Checker Logic", test_num);
            reset_dut();


            d1 = 8'h03;
            d2 = 8'h01;

            select = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mode Switching - DFF Load then Shift", test_num);
            reset_dut();


            d1 = 8'hFF; d2 = 8'h00; select = 0;
            @(posedge clk);


            d1 = 8'h00; d2 = 8'h00; select = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Complex Parity (Even number of 1s)", test_num);
            reset_dut();

            d1 = 8'hAA;
            d2 = 8'h55;

            select = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'hAA);
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
        input expected_error_flag;
        input [7:0] expected_q;
        begin
            if (expected_error_flag === (expected_error_flag ^ error_flag ^ expected_error_flag) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: error_flag=%b, q=%h",
                         error_flag, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_flag=%b, q=%h",
                         expected_error_flag, expected_q);
                $display("  Got:      error_flag=%b, q=%h",
                         error_flag, q);
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
        $dumpvars(0,clk, d1, d2, select, error_flag, q);
    end

endmodule
