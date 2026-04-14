`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] r;
    wire [6:0] c;
    wire [3:0] d;
    wire [6:0] e;
    wire [2:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r(r),
        .c(c),
        .d(d),
        .e(e),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            r = 7'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            r = 7'b0000000;
            @(posedge clk);
            #1;
            $display("Test %0d: All Zeros (No Error)", test_num);
            #1;

            check_outputs(7'h00, 4'h0, 7'h00, 3'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            r = 7'b0000001;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[0] (Pos 1)", test_num);
            #1;

            check_outputs(7'h00, 4'h1, 7'h01, 3'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            r = 7'b0000010;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[1] (Pos 2)", test_num);
            #1;

            check_outputs(7'h00, 4'h2, 7'h02, 3'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            r = 7'b0000100;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[2] (Pos 3)", test_num);
            #1;

            check_outputs(7'h00, 4'h3, 7'h04, 3'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            r = 7'b0001000;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[3] (Pos 4)", test_num);
            #1;

            check_outputs(7'h00, 4'h4, 7'h08, 3'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            r = 7'b1000000;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[6] (Pos 7)", test_num);
            #1;

            check_outputs(7'h00, 4'h7, 7'h40, 3'h7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            r = 7'h2D;
            @(posedge clk);
            #1;
            $display("Test %0d: Valid Codeword 0x2D", test_num);
            #1;

            check_outputs(7'h2D, 4'h0, 7'h00, 3'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            r = 7'h2C;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[0] of Codeword 0x2D", test_num);
            #1;

            check_outputs(7'h2D, 4'h1, 7'h01, 3'h1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            r = 7'h3D;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[4] (Pos 5) of Codeword 0x2D", test_num);
            #1;

            check_outputs(7'h2D, 4'h5, 7'h10, 3'h5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            r = 7'h0D;
            @(posedge clk);
            #1;
            $display("Test %0d: Error at r[5] (Pos 6) of Codeword 0x2D", test_num);
            #1;

            check_outputs(7'h2D, 4'h6, 7'h20, 3'h6);
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
        input [6:0] expected_c;
        input [3:0] expected_d;
        input [6:0] expected_e;
        input [2:0] expected_s;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: c=%h, d=%h, e=%h, s=%h",
                         c, d, e, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, d=%h, e=%h, s=%h",
                         expected_c, expected_d, expected_e, expected_s);
                $display("  Got:      c=%h, d=%h, e=%h, s=%h",
                         c, d, e, s);
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
        $dumpvars(0,clk, r, c, d, e, s);
    end

endmodule
