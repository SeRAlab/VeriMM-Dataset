`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr;
    reg c;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .c(c),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            addr = 5'd0;
            @(posedge c);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase001: Address 0");
            addr = 5'd0;
            @(posedge c);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase002: Address 1");
            addr = 5'd1;
            @(posedge c);
            #1;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase003: Address 15");
            addr = 5'd15;
            @(posedge c);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase004: Address 31");
            addr = 5'd31;
            @(posedge c);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase005: Address 7");
            addr = 5'd7;
            @(posedge c);
            #1;
            #1;

            check_outputs(32'h77777777);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,addr, c, q);
    end

endmodule
