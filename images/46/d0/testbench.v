`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] copy_enable;
    reg vblank;
    wire [12:0] back_vram_addr;
    wire back_vram_rd_low;
    wire copy_in_progress;
    wire [12:0] front_vram_addr;
    wire front_vram_wr_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .copy_enable(copy_enable),
        .vblank(vblank),
        .back_vram_addr(back_vram_addr),
        .back_vram_rd_low(back_vram_rd_low),
        .copy_in_progress(copy_in_progress),
        .front_vram_addr(front_vram_addr),
        .front_vram_wr_low(front_vram_wr_low)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            vblank = 0;
            copy_enable = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Idle State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(13'h0, 1'b1, 1'b0, 13'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: VBlank Only (No Trigger)");
            test_num = 2;
            reset_dut();
            vblank = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(13'h0, 1'b1, 1'b0, 13'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Copy Enable Only (No Trigger)");
            test_num = 3;
            reset_dut();
            copy_enable = 8'hAA;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(13'h0, 1'b1, 1'b0, 13'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Copy Start (Cycle 0)");
            test_num = 4;
            reset_dut();
            vblank = 1;
            copy_enable = 8'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(13'd0, 1'b0, 1'b1, 13'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mid-Copy Progress (Cycle 1000)");
            test_num = 5;
            reset_dut();
            vblank = 1;
            copy_enable = 8'hFF;
            @(posedge clk);
            repeat(1000) @(posedge clk);
            #1;

            #1;


            check_outputs(13'd1000, 1'b0, 1'b1, 13'd1000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Final Transfer Cycle (4799)");
            test_num = 6;
            reset_dut();
            vblank = 1;
            copy_enable = 8'h01;
            @(posedge clk);
            repeat(4799) @(posedge clk);
            #1;

            #1;


            check_outputs(13'd4799, 1'b0, 1'b1, 13'd4799, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Completion and Cleanup");
            test_num = 7;
            reset_dut();
            vblank = 1;
            copy_enable = 8'h01;
            @(posedge clk);
            repeat(4800) @(posedge clk);
            #1;

            #1;


            check_outputs(13'h0, 1'b1, 1'b0, 13'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Abort on VBlank Falling Edge");
            test_num = 8;
            reset_dut();
            vblank = 1;
            copy_enable = 8'h01;
            @(posedge clk);
            repeat(100) @(posedge clk);
            vblank = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(13'h0, 1'b1, 1'b0, 13'h0, 1'b1);
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
        input [12:0] expected_back_vram_addr;
        input expected_back_vram_rd_low;
        input expected_copy_in_progress;
        input [12:0] expected_front_vram_addr;
        input expected_front_vram_wr_low;
        begin
            if (expected_back_vram_addr === (expected_back_vram_addr ^ back_vram_addr ^ expected_back_vram_addr) &&
                expected_back_vram_rd_low === (expected_back_vram_rd_low ^ back_vram_rd_low ^ expected_back_vram_rd_low) &&
                expected_copy_in_progress === (expected_copy_in_progress ^ copy_in_progress ^ expected_copy_in_progress) &&
                expected_front_vram_addr === (expected_front_vram_addr ^ front_vram_addr ^ expected_front_vram_addr) &&
                expected_front_vram_wr_low === (expected_front_vram_wr_low ^ front_vram_wr_low ^ expected_front_vram_wr_low)) begin
                $display("PASS");
                $display("  Outputs: back_vram_addr=%h, back_vram_rd_low=%b, copy_in_progress=%b, front_vram_addr=%h, front_vram_wr_low=%b",
                         back_vram_addr, back_vram_rd_low, copy_in_progress, front_vram_addr, front_vram_wr_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: back_vram_addr=%h, back_vram_rd_low=%b, copy_in_progress=%b, front_vram_addr=%h, front_vram_wr_low=%b",
                         expected_back_vram_addr, expected_back_vram_rd_low, expected_copy_in_progress, expected_front_vram_addr, expected_front_vram_wr_low);
                $display("  Got:      back_vram_addr=%h, back_vram_rd_low=%b, copy_in_progress=%b, front_vram_addr=%h, front_vram_wr_low=%b",
                         back_vram_addr, back_vram_rd_low, copy_in_progress, front_vram_addr, front_vram_wr_low);
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
        $dumpvars(0,clk, copy_enable, vblank, back_vram_addr, back_vram_rd_low, copy_in_progress, front_vram_addr, front_vram_wr_low);
    end

endmodule
