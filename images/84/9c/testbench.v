`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
    reg clk;
    reg [31:0] r15;
    reg [31:0] wd3;
    reg we3;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .clk(clk),
        .r15(r15),
        .wd3(wd3),
        .we3(we3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we3 = 0;
            a1 = 0;
            a2 = 0;
            a3 = 0;
            wd3 = 0;
            r15 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Basic Write and Read (Reg 1)", test_num);
            we3 = 1;
            a3 = 4'd1;
            wd3 = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;
            we3 = 0;
            a1 = 4'd1;
            a2 = 4'd0;
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Verify Write Enable Inhibit", test_num);

            we3 = 0;
            a3 = 4'd2;
            wd3 = 32'h5555_6666;
            @(posedge clk);
            #1;
            a1 = 4'd2;
            #1;
            #1;

            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Special Register 15 (r15 port bypass)", test_num);
            r15 = 32'hDEAD_BEEF;
            a1 = 4'b1111;
            a2 = 4'd0;
            #1;
            #1;

            check_outputs(32'hDEAD_BEEF, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Special Register 15 Dynamic Port 2", test_num);
            r15 = 32'h1234_5678;
            a2 = 4'b1111;
            #1;

            if (rd2 !== 32'h1234_5678) begin
                $display("  Sub-check 1 failed");
            end

            r15 = 32'h8765_4321;
            #1;
            #1;

            check_outputs(32'h0000_0000, 32'h8765_4321);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Dual Read (Reg 3 and Reg 4)", test_num);

            we3 = 1; a3 = 4'd3; wd3 = 32'h3333_3333;
            @(posedge clk);

            #1; a3 = 4'd4; wd3 = 32'h4444_4444;
            @(posedge clk);
            #1;
            we3 = 0;
            a1 = 4'd3;
            a2 = 4'd4;
            #1;
            #1;

            check_outputs(32'h3333_3333, 32'h4444_4444);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Register 15 Priority Test", test_num);
            r15 = 32'hFFFF_FFFF;
            we3 = 1;
            a3 = 4'd15;
            wd3 = 32'h0000_0000;
            @(posedge clk);
            #1;
            a1 = 4'd15;
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 32'h0000_0000);
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,a1, a2, a3, clk, r15, wd3, we3, rd1, rd2);
    end

endmodule
