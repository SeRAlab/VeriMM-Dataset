`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clkrst_core_clk;
    reg clkrst_core_rst_n;
    reg en;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clkrst_core_clk(clkrst_core_clk),
        .clkrst_core_rst_n(clkrst_core_rst_n),
        .en(en),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clkrst_core_clk = 0;
        forever #5 clkrst_core_clk = ~clkrst_core_clk;
    end

        task reset_dut;

        begin
            clkrst_core_rst_n = 1;
            en = 0;
            D = 0;
            #2;
            clkrst_core_rst_n = 0;
            #10;
            clkrst_core_rst_n = 1;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Writing 0xAA with en=1", test_num);
            reset_dut();

            @(negedge clkrst_core_clk);
            D = 8'hAA;
            en = 1;
            @(posedge clkrst_core_clk);
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Verifying en=0 inhibits write", test_num);
            reset_dut();

            @(negedge clkrst_core_clk);
            D = 8'hFF;
            en = 0;
            @(posedge clkrst_core_clk);
            #2;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Verifying data hold when en toggles", test_num);
            reset_dut();


            @(negedge clkrst_core_clk);
            D = 8'h55;
            en = 1;
            @(posedge clkrst_core_clk);


            @(negedge clkrst_core_clk);
            D = 8'hCC;
            en = 0;
            @(posedge clkrst_core_clk);
            #2;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verifying Asynchronous Reset mid-cycle", test_num);
            reset_dut();


            @(negedge clkrst_core_clk);
            D = 8'h77;
            en = 1;
            @(posedge clkrst_core_clk);
            #2;


            #3;
            clkrst_core_rst_n = 0;
            #1;


            #1;



            check_outputs(8'h00);


            clkrst_core_rst_n = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple consecutive writes", test_num);
            reset_dut();

            @(negedge clkrst_core_clk);
            en = 1;
            D = 8'h01;
            @(posedge clkrst_core_clk);

            @(negedge clkrst_core_clk);
            D = 8'h02;
            @(posedge clkrst_core_clk);

            @(negedge clkrst_core_clk);
            D = 8'h03;
            @(posedge clkrst_core_clk);
            #2;

            #1;


            check_outputs(8'h03);
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clkrst_core_clk, clkrst_core_rst_n, en, Q);
    end

endmodule
