`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg [31:0] pc;
    wire [31:0] pcout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .pc(pc),
        .pcout(pcout)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            pc <= 0;

            repeat(5) @(posedge CLOCK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: PC = 0", test_num);
            pc <= 32'd0;

            repeat(4) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(32'd4);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: PC = 1000", test_num);
            pc <= 32'd1000;
            repeat(4) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(32'd1004);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: PC = -4", test_num);
            pc <= -32'd4;
            repeat(4) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: PC = 2147483643 (Max-4)", test_num);
            pc <= 32'h7FFF_FFFB;
            repeat(4) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(32'h7FFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: PC = 0xDEADBEE0", test_num);
            pc <= 32'hDEADBEE0;
            repeat(4) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(32'hDEADBEE4);
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
        input [31:0] expected_pcout;
        begin
            if (expected_pcout === (expected_pcout ^ pcout ^ expected_pcout)) begin
                $display("PASS");
                $display("  Outputs: pcout=%h",
                         pcout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcout=%h",
                         expected_pcout);
                $display("  Got:      pcout=%h",
                         pcout);
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
        $dumpvars(0,CLOCK, pc, pcout);
    end

endmodule
