`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ra;
    reg sys_clk;
    reg [2:0] wa;
    reg [31:0] wd;
    reg we;
    wire [63:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ra(ra),
        .sys_clk(sys_clk),
        .wa(wa),
        .wd(wd),
        .we(we),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            we = 0;
            wa = 0;
            wd = 0;
            ra = 0;
            @(posedge sys_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            we = 1; wa = 3'd0; wd = 32'hDEADBEEF;
            @(posedge sys_clk);

            we = 1; wa = 3'd1; wd = 32'hCAFEBABE;
            @(posedge sys_clk);
            we = 0;
            ra = 2'd0;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(64'hCAFEBABE_DEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            we = 1; wa = 3'd2; wd = 32'h11112222;
            @(posedge sys_clk);

            we = 1; wa = 3'd3; wd = 32'h33334444;
            @(posedge sys_clk);
            we = 0;
            ra = 2'd1;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(64'h33334444_11112222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            we = 1; wa = 3'd4; wd = 32'h55556666;
            @(posedge sys_clk);

            we = 1; wa = 3'd5; wd = 32'h77778888;
            @(posedge sys_clk);
            we = 0;
            ra = 2'd2;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(64'h77778888_55556666);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            we = 1; wa = 3'd6; wd = 32'hAAAA_BBBB;
            @(posedge sys_clk);

            we = 1; wa = 3'd7; wd = 32'hCCCC_DDDD;
            @(posedge sys_clk);
            we = 0;
            ra = 2'd3;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(64'hCCCC_DDDD_AAAA_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            we = 1; wa = 3'd0; wd = 32'h12345678; @(posedge sys_clk);
            we = 1; wa = 3'd1; wd = 32'h87654321; @(posedge sys_clk);

            we = 0; wa = 3'd0; wd = 32'hFFFFFFFF; @(posedge sys_clk);
            ra = 2'd0;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(64'h87654321_12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            we = 1; wa = 3'd4; wd = 32'h00001111; @(posedge sys_clk);
            we = 1; wa = 3'd5; wd = 32'h00002222; @(posedge sys_clk);

            we = 1; wa = 3'd4; wd = 32'hEEEEFFFF; @(posedge sys_clk);
            we = 0;
            ra = 2'd2;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(64'h00002222_EEEEFFFF);
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
        input [63:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,ra, sys_clk, wa, wd, we, rd);
    end

endmodule
