`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [3:0] op;
    reg [31:0] valA;
    reg [31:0] valB;
    reg [31:0] valC;
    wire done;
    wire [31:0] valZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .op(op),
        .valA(valA),
        .valB(valB),
        .valC(valC),
        .done(done),
        .valZ(valZ)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            op = 0;
            valA = 0;
            valB = 0;
            valC = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task wait_and_check;

        input [31:0] expected_valZ;
        begin

            fork: wait_or_timeout
                begin
                    wait(done == 1'b1);
                end
                begin
                    repeat (20) @(posedge clk);
                end
            join_any
            disable wait_or_timeout;

            if (done) begin
                #1;

                check_outputs(1'b1, expected_valZ);
            end else begin
                $display("FAIL: Operation timed out (done signal never asserted)");
                fail_count = fail_count + 1;
            end


            en = 0;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Addition (10 + 20)");
            reset_dut();
            test_num = 1;
            en = 1; op = 4'd0; valA = 32'd10; valB = 32'd20; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'd30);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (100 - 45)");
            reset_dut();
            test_num = 2;
            en = 1; op = 4'd1; valA = 32'd100; valB = 32'd45; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'd55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bitwise AND (0xFFFF0000 & 0xAAAA_BBBB)");
            reset_dut();
            test_num = 3;
            en = 1; op = 4'd2; valA = 32'hFFFF0000; valB = 32'hAAAABBBB; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'hAAAA0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise OR (0xF0F0F0F0 | 0x0F0F0F0F)");
            reset_dut();
            test_num = 4;
            en = 1; op = 4'd3; valA = 32'hF0F0F0F0; valB = 32'h0F0F0F0F; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: SLL (1 << 4)");
            reset_dut();
            test_num = 5;
            en = 1; op = 4'd4; valA = 32'd1; valB = 32'd4; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'h00000010);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: SRL (0x80000000 >> 1)");
            reset_dut();
            test_num = 6;
            en = 1; op = 4'd5; valA = 32'h80000000; valB = 32'd1; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'h40000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: SRA (0x80000000 >>> 1)");
            reset_dut();
            test_num = 7;
            en = 1; op = 4'd6; valA = 32'h80000000; valB = 32'd1; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'hC0000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Addition with valC (10 + 20 + 5)");
            reset_dut();
            test_num = 8;
            en = 1; op = 4'd0; valA = 32'd10; valB = 32'd20; valC = 32'd5;
            @(posedge clk);
            wait_and_check(32'd35);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Signed Addition (-50 + 20)");
            reset_dut();
            test_num = 9;
            en = 1; op = 4'd0; valA = -32'sd50; valB = 32'sd20; valC = 32'd0;
            @(posedge clk);
            wait_and_check(-32'sd30);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Max Integer + 1");
            reset_dut();
            test_num = 10;
            en = 1; op = 4'd0; valA = 32'h7FFFFFFF; valB = 32'd1; valC = 32'd0;
            @(posedge clk);
            wait_and_check(32'h80000000);
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
        input expected_done;
        input [31:0] expected_valZ;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_valZ === (expected_valZ ^ valZ ^ expected_valZ)) begin
                $display("PASS");
                $display("  Outputs: done=%b, valZ=%h",
                         done, valZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, valZ=%h",
                         expected_done, expected_valZ);
                $display("  Got:      done=%b, valZ=%h",
                         done, valZ);
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
        $dumpvars(0,clk, en, op, valA, valB, valC, done, valZ);
    end

endmodule
