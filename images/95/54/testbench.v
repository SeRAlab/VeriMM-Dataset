`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] ain;
    reg [15:0] bin;
    reg clk;
    reg resetb;
    reg start;
    wire done;
    wire [31:0] yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .clk(clk),
        .resetb(resetb),
        .start(start),
        .done(done),
        .yout(yout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetb = 0;
        start = 0;
        ain = 0;
        bin = 0;
        repeat(2) @(posedge clk);
        #1 resetb = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task perform_mult;

        input [15:0] a;
        input [15:0] b;
        begin
            ain = a;
            bin = b;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            fork: wait_or_timeout
                begin
                    wait(done == 1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any
            disable wait_or_timeout;


            @(posedge clk);
            #1;

            check_outputs(1'b1, a * b);
        end
        endtask

    task testcase001;

    begin
        $display("Testcase 001: Basic Multiplication (10 * 5)");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'd10, 16'd5);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Multiplication by Zero (0 * 1234)");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'd0, 16'd1234);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Multiplication by One (1 * 0xFFFF)");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'd1, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Maximum Values (0xFFFF * 0xFFFF)");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'hFFFF, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Power of Two (256 * 128)");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'd256, 16'd128);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Pattern Multiplication (0xAAAA * 0x5555)");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'hAAAA, 16'h5555);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Random Value 1");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'h1234, 16'hABCD);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Small and Large (2 * 32768)");
        test_num = test_num + 1;
        reset_dut();
        perform_mult(16'd2, 16'd32768);
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
        input expected_done;
        input [31:0] expected_yout;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: done=%b, yout=%h",
                         done, yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, yout=%h",
                         expected_done, expected_yout);
                $display("  Got:      done=%b, yout=%h",
                         done, yout);
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
        $dumpvars(0,ain, bin, clk, resetb, start, done, yout);
    end

endmodule
