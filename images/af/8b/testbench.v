`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] out_le;
    reg rst;
    reg sdata_in;
    wire [15:0] slt0;
    wire [19:0] slt1;
    wire [19:0] slt2;
    wire [19:0] slt3;
    wire [19:0] slt4;
    wire [19:0] slt6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .out_le(out_le),
        .rst(rst),
        .sdata_in(sdata_in),
        .slt0(slt0),
        .slt1(slt1),
        .slt2(slt2),
        .slt3(slt3),
        .slt4(slt4),
        .slt6(slt6)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            out_le = 6'b0;
            sdata_in = 1'b0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0, 20'h0, 20'h0, 20'h0, 20'h0, 20'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load slt0 (16-bit)", test_num);
            reset_dut();
            shift_data(20'hA5A5A);
            out_le = 6'b000001;
            @(posedge clk);
            #1 out_le = 6'b000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h5A5A, 20'h0, 20'h0, 20'h0, 20'h0, 20'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load slt1 (20-bit)", test_num);
            reset_dut();
            shift_data(20'h12345);
            out_le = 6'b000010;
            @(posedge clk);
            #1 out_le = 6'b000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0, 20'h12345, 20'h0, 20'h0, 20'h0, 20'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Simultaneous Load slt2 and slt3", test_num);
            reset_dut();
            shift_data(20'hBCDEF);
            out_le = 6'b001100;
            @(posedge clk);
            #1 out_le = 6'b000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0, 20'h0, 20'hBCDEF, 20'hBCDEF, 20'h0, 20'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load slt6", test_num);
            reset_dut();
            shift_data(20'hFFFFF);
            out_le = 6'b100000;
            @(posedge clk);
            #1 out_le = 6'b000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0, 20'h0, 20'h0, 20'h0, 20'h0, 20'hFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sequential Load and Persistence", test_num);
            reset_dut();


            shift_data(20'h88888);
            out_le = 6'b010000;
            @(posedge clk);
            #1 out_le = 6'b000000;


            shift_data(20'h11111);
            out_le = 6'b000001;
            @(posedge clk);
            #1 out_le = 6'b000000;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h1111, 20'h0, 20'h0, 20'h0, 20'h88888, 20'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Overflow Shift Check", test_num);
            reset_dut();

            shift_data(20'hAAAAA);
            shift_data(20'h55555);
            out_le = 6'b000010;
            @(posedge clk);
            #1 out_le = 6'b000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0, 20'h55555, 20'h0, 20'h0, 20'h0, 20'h0);
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
        input [15:0] expected_slt0;
        input [19:0] expected_slt1;
        input [19:0] expected_slt2;
        input [19:0] expected_slt3;
        input [19:0] expected_slt4;
        input [19:0] expected_slt6;
        begin
            if (expected_slt0 === (expected_slt0 ^ slt0 ^ expected_slt0) &&
                expected_slt1 === (expected_slt1 ^ slt1 ^ expected_slt1) &&
                expected_slt2 === (expected_slt2 ^ slt2 ^ expected_slt2) &&
                expected_slt3 === (expected_slt3 ^ slt3 ^ expected_slt3) &&
                expected_slt4 === (expected_slt4 ^ slt4 ^ expected_slt4) &&
                expected_slt6 === (expected_slt6 ^ slt6 ^ expected_slt6)) begin
                $display("PASS");
                $display("  Outputs: slt0=%h, slt1=%h, slt2=%h, slt3=%h, slt4=%h, slt6=%h",
                         slt0, slt1, slt2, slt3, slt4, slt6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: slt0=%h, slt1=%h, slt2=%h, slt3=%h, slt4=%h, slt6=%h",
                         expected_slt0, expected_slt1, expected_slt2, expected_slt3, expected_slt4, expected_slt6);
                $display("  Got:      slt0=%h, slt1=%h, slt2=%h, slt3=%h, slt4=%h, slt6=%h",
                         slt0, slt1, slt2, slt3, slt4, slt6);
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
        $dumpvars(0,clk, out_le, rst, sdata_in, slt0, slt1, slt2, slt3, slt4, slt6);
    end

endmodule
