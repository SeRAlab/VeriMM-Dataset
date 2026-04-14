`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_b;
    reg i_c;
    reg i_d;
    reg i_i;
    reg i_n;
    reg i_set_b;
    reg i_set_c;
    reg i_set_d;
    reg i_set_i;
    reg i_set_n;
    reg i_set_v;
    reg i_set_z;
    reg i_v;
    reg i_z;
    reg rst_x;
    wire [7:0] o_psr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_b(i_b),
        .i_c(i_c),
        .i_d(i_d),
        .i_i(i_i),
        .i_n(i_n),
        .i_set_b(i_set_b),
        .i_set_c(i_set_c),
        .i_set_d(i_set_d),
        .i_set_i(i_set_i),
        .i_set_n(i_set_n),
        .i_set_v(i_set_v),
        .i_set_z(i_set_z),
        .i_v(i_v),
        .i_z(i_z),
        .rst_x(rst_x),
        .o_psr(o_psr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_x = 0;
            i_b = 0; i_c = 0; i_d = 0; i_i = 0; i_n = 0; i_v = 0; i_z = 0;
            i_set_b = 0; i_set_c = 0; i_set_d = 0; i_set_i = 0; i_set_n = 0; i_set_v = 0; i_set_z = 0;
            @(posedge clk);
            #2 rst_x = 0;
            #10 rst_x = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Power-on Reset check", test_num);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Set Carry (C) flag", test_num);
            i_c = 1; i_set_c = 1;
            @(posedge clk);
            #2 i_set_c = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Set Zero (Z) flag", test_num);
            i_z = 1; i_set_z = 1;
            @(posedge clk);
            #2 i_set_z = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Set Interrupt (I) flag", test_num);
            i_i = 1; i_set_i = 1;
            @(posedge clk);
            #2 i_set_i = 0;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Set Decimal (D) flag", test_num);
            i_d = 1; i_set_d = 1;
            @(posedge clk);
            #2 i_set_d = 0;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Set Break (B) flag", test_num);
            i_b = 1; i_set_b = 1;
            @(posedge clk);
            #2 i_set_b = 0;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Set Overflow (V) flag", test_num);
            i_v = 1; i_set_v = 1;
            @(posedge clk);
            #2 i_set_v = 0;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Set Negative (N) flag", test_num);
            i_n = 1; i_set_n = 1;
            @(posedge clk);
            #2 i_set_n = 0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Simultaneous update of all flags", test_num);
            i_c=1; i_z=1; i_i=1; i_d=1; i_b=1; i_v=1; i_n=1;
            i_set_c=1; i_set_z=1; i_set_i=1; i_set_d=1; i_set_b=1; i_set_v=1; i_set_n=1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hDF);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: Write Enable Gating Check", test_num);

            i_n = 1; i_set_n = 1;
            @(posedge clk);
            #2;

            i_n = 0; i_set_n = 0;
            i_c = 1; i_set_c = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h81);
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
        testcase010();
        
        
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
        input [7:0] expected_o_psr;
        begin
            if (expected_o_psr === (expected_o_psr ^ o_psr ^ expected_o_psr)) begin
                $display("PASS");
                $display("  Outputs: o_psr=%h",
                         o_psr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_psr=%h",
                         expected_o_psr);
                $display("  Got:      o_psr=%h",
                         o_psr);
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
        $dumpvars(0,clk, i_b, i_c, i_d, i_i, i_n, i_set_b, i_set_c, i_set_d, i_set_i, i_set_n, i_set_v, i_set_z, i_v, i_z, rst_x, o_psr);
    end

endmodule
