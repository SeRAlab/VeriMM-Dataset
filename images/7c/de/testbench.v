`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ra1;
    reg [2:0] ra2;
    reg regwrite;
    reg [2:0] wa;
    reg [7:0] wd;
    wire [7:0] rd1;
    wire [7:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .regwrite(regwrite),
        .wa(wa),
        .wd(wd),
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
            regwrite = 0;
            ra1 = 0;
            ra2 = 0;
            wa = 0;
            wd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Register 0 (Should always be 0)", test_num);
            reset_dut();

            wa = 3'd0;
            wd = 8'hFF;
            regwrite = 1;
            @(posedge clk);
            #1;
            regwrite = 0;

            ra1 = 3'd0;
            ra2 = 3'd0;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read (Reg 1)", test_num);
            reset_dut();
            wa = 3'd1;
            wd = 8'hA5;
            regwrite = 1;
            @(posedge clk);
            #1;
            regwrite = 0;
            ra1 = 3'd1;
            ra2 = 3'd0;
            #1;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Dual Port Read (Reg 2 and Reg 3)", test_num);
            reset_dut();

            wa = 3'd2; wd = 8'h11; regwrite = 1;
            @(posedge clk); #1;

            wa = 3'd3; wd = 8'h22; regwrite = 1;
            @(posedge clk); #1;
            regwrite = 0;

            ra1 = 3'd2;
            ra2 = 3'd3;
            #1;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Check (regwrite=0)", test_num);
            reset_dut();

            wa = 3'd4; wd = 8'h55; regwrite = 1;
            @(posedge clk); #1;

            wa = 3'd4; wd = 8'hAA; regwrite = 0;
            @(posedge clk); #1;
            ra1 = 3'd4;
            ra2 = 3'd0;
            #1;
            #1;

            check_outputs(8'h55, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Address Check (Reg 7)", test_num);
            reset_dut();
            wa = 3'd7; wd = 8'h7F; regwrite = 1;
            @(posedge clk); #1;
            regwrite = 0;
            ra1 = 3'd7;
            ra2 = 3'd0;
            #1;
            #1;

            check_outputs(8'h7F, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data Range Check (0x00 and 0xFF)", test_num);
            reset_dut();
            wa = 3'd5; wd = 8'h00; regwrite = 1;
            @(posedge clk); #1;
            wa = 3'd6; wd = 8'hFF; regwrite = 1;
            @(posedge clk); #1;
            regwrite = 0;
            ra1 = 3'd5;
            ra2 = 3'd6;
            #1;
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Overwrite Check", test_num);
            reset_dut();
            wa = 3'd2; wd = 8'hCC; regwrite = 1;
            @(posedge clk); #1;
            wa = 3'd2; wd = 8'h33; regwrite = 1;
            @(posedge clk); #1;
            regwrite = 0;
            ra1 = 3'd2;
            ra2 = 3'd0;
            #1;
            #1;

            check_outputs(8'h33, 8'h00);
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
        input [7:0] expected_rd1;
        input [7:0] expected_rd2;
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
        $dumpvars(0,clk, ra1, ra2, regwrite, wa, wd, rd1, rd2);
    end

endmodule
