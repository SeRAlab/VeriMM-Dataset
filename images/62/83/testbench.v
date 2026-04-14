`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] ex;
    reg [24:0] mxy1;
    reg s;
    reg s1;
    reg s2;
    reg s3;
    wire [7:0] exy;
    wire [23:0] mxy;
    wire sr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ex(ex),
        .mxy1(mxy1),
        .s(s),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .exy(exy),
        .mxy(mxy),
        .sr(sr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            mxy1 = 25'b0;
            ex = 8'b0;
            s = 1'b0;
            s1 = 1'b0;
            s2 = 1'b0;
            s3 = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Already Normalized", test_num);
            mxy1 = 25'h0800000;
            ex   = 8'h7F;
            s = 0; s1 = 0; s2 = 0; s3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h7F, 24'h800000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Shift Left 1", test_num);
            mxy1 = 25'h0400000;
            ex   = 8'h80;
            s = 0; s1 = 0; s2 = 0; s3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h7F, 24'h800000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Shift Left 8", test_num);
            mxy1 = 25'h0008000;
            ex   = 8'h64;
            s = 0; s1 = 0; s2 = 0; s3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5C, 24'h800000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Maximum Shift Left", test_num);
            mxy1 = 25'h0000001;
            ex   = 8'h20;
            s = 0; s1 = 0; s2 = 0; s3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h09, 24'h800000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Zero Mantissa", test_num);
            mxy1 = 25'h0000000;
            ex   = 8'h7F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 24'h000000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Sign Inversion Handling", test_num);

            mxy1 = 25'h0800000;
            ex   = 8'h7F;
            s = 1; s1 = 0; s2 = 0; s3 = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h7F, 24'h800000, 1'b1);
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
        input [7:0] expected_exy;
        input [23:0] expected_mxy;
        input expected_sr;
        begin
            if (expected_exy === (expected_exy ^ exy ^ expected_exy) &&
                expected_mxy === (expected_mxy ^ mxy ^ expected_mxy) &&
                expected_sr === (expected_sr ^ sr ^ expected_sr)) begin
                $display("PASS");
                $display("  Outputs: exy=%h, mxy=%h, sr=%b",
                         exy, mxy, sr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exy=%h, mxy=%h, sr=%b",
                         expected_exy, expected_mxy, expected_sr);
                $display("  Got:      exy=%h, mxy=%h, sr=%b",
                         exy, mxy, sr);
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
        $dumpvars(0,clk, ex, mxy1, s, s1, s2, s3, exy, mxy, sr);
    end

endmodule
