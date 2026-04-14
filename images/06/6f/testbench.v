`timescale 1ns/1ps

module SISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_Shift_Register dut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            si = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Shift in 1-0-0-0-0. Expect 1 at output after 5 cycles.");
            test_num = 1;
            reset_dut();

            @(negedge clk) si = 1;

            @(negedge clk) si = 0;
            @(negedge clk) si = 0;
            @(negedge clk) si = 0;
            @(negedge clk) si = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift in 0-1-1-1-1. Expect 0 at output after 5 cycles.");
            test_num = 2;
            reset_dut();

            @(negedge clk) si = 0;

            @(negedge clk) si = 1;
            @(negedge clk) si = 1;
            @(negedge clk) si = 1;
            @(negedge clk) si = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift in all 1s (1-1-1-1-1). Expect 1 at output.");
            test_num = 3;
            reset_dut();
            repeat(5) begin
                @(negedge clk) si = 1;
            end
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift in all 0s (0-0-0-0-0). Expect 0 at output.");
            test_num = 4;
            reset_dut();
            repeat(5) begin
                @(negedge clk) si = 0;
            end
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating bits 1-0-1-0-1. Expect 1 at output.");
            test_num = 5;
            reset_dut();
            @(negedge clk) si = 1;
            @(negedge clk) si = 0;
            @(negedge clk) si = 1;
            @(negedge clk) si = 0;
            @(negedge clk) si = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating bits 0-1-0-1-0. Expect 0 at output.");
            test_num = 6;
            reset_dut();
            @(negedge clk) si = 0;
            @(negedge clk) si = 1;
            @(negedge clk) si = 0;
            @(negedge clk) si = 1;
            @(negedge clk) si = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SISO_Shift_Register Testbench");
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
        input expected_so;
        begin
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%b",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%b",
                         expected_so);
                $display("  Got:      so=%b",
                         so);
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
        $dumpvars(0,clk, rst, si, so);
    end

endmodule
