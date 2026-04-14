`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] E_src1;
    reg [31:0] E_src2;
    reg M_en;
    reg clk;
    reg reset_n;
    wire [31:0] M_mul_cell_p1;
    wire [31:0] M_mul_cell_p2;
    wire [31:0] M_mul_cell_p3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E_src1(E_src1),
        .E_src2(E_src2),
        .M_en(M_en),
        .clk(clk),
        .reset_n(reset_n),
        .M_mul_cell_p1(M_mul_cell_p1),
        .M_mul_cell_p2(M_mul_cell_p2),
        .M_mul_cell_p3(M_mul_cell_p3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        E_src1 = 0;
        E_src2 = 0;
        M_en = 0;
        @(posedge clk);
        #1 reset_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset State Check", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Multiplication (1 x 1)", test_num);
        reset_dut();
        M_en = 1;
        E_src1 = 32'h0001_0001;
        E_src2 = 32'h0001_0001;




        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(32'h1, 32'h2, 32'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed Halves (2,3 x 4,5)", test_num);
        reset_dut();
        M_en = 1;
        E_src1 = 32'h0002_0003;
        E_src2 = 32'h0004_0005;




        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(32'hF, 32'h16, 32'h8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable Signal Logic", test_num);
        reset_dut();
        M_en = 0;
        E_src1 = 32'hFFFF_FFFF;
        E_src2 = 32'hFFFF_FFFF;
        @(posedge clk);
        @(posedge clk);
        #1;

        if (M_mul_cell_p1 == 0) begin
            $display("PASS: Output stayed zero while disabled");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Output changed while disabled");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Values", test_num);
        reset_dut();
        M_en = 1;
        E_src1 = 32'hFFFF_FFFF;
        E_src2 = 32'hFFFF_FFFF;



        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(32'hFFFE0001, 32'hFFFC0002, 32'hFFFE0001);
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
        input [31:0] expected_M_mul_cell_p1;
        input [31:0] expected_M_mul_cell_p2;
        input [31:0] expected_M_mul_cell_p3;
        begin
            if (expected_M_mul_cell_p1 === (expected_M_mul_cell_p1 ^ M_mul_cell_p1 ^ expected_M_mul_cell_p1) &&
                expected_M_mul_cell_p2 === (expected_M_mul_cell_p2 ^ M_mul_cell_p2 ^ expected_M_mul_cell_p2) &&
                expected_M_mul_cell_p3 === (expected_M_mul_cell_p3 ^ M_mul_cell_p3 ^ expected_M_mul_cell_p3)) begin
                $display("PASS");
                $display("  Outputs: M_mul_cell_p1=%h, M_mul_cell_p2=%h, M_mul_cell_p3=%h",
                         M_mul_cell_p1, M_mul_cell_p2, M_mul_cell_p3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_mul_cell_p1=%h, M_mul_cell_p2=%h, M_mul_cell_p3=%h",
                         expected_M_mul_cell_p1, expected_M_mul_cell_p2, expected_M_mul_cell_p3);
                $display("  Got:      M_mul_cell_p1=%h, M_mul_cell_p2=%h, M_mul_cell_p3=%h",
                         M_mul_cell_p1, M_mul_cell_p2, M_mul_cell_p3);
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
        $dumpvars(0,E_src1, E_src2, M_en, clk, reset_n, M_mul_cell_p1, M_mul_cell_p2, M_mul_cell_p3);
    end

endmodule
