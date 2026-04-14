`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cs_n;
    reg reset_n;
    reg sclk;
    reg sdi;
    wire sdo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cs_n(cs_n),
        .reset_n(reset_n),
        .sclk(sclk),
        .sdi(sdi),
        .sdo(sdo)
    );

    // Clock generation (10ns period)
    initial begin
        cs_n = 0;
        forever #5 cs_n = ~cs_n;
    end

        task reset_dut;

        begin
            reset_n = 0;
            cs_n = 1;
            sdi = 0;
            #20;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 255, Check Result Bit 15 (Expected: 1)", test_num);
            reset_dut();
            cs_n = 0;
            send_byte(8'hFF);

            repeat(9) @(posedge sclk);
            #2 #1;
 check_outputs(1'b1);
            cs_n = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1, Check Result Bit 0 (Expected: 1)", test_num);
            reset_dut();
            cs_n = 0;
            send_byte(8'h01);

            repeat(24) @(posedge sclk);
            #2 #1;
 check_outputs(1'b1);
            cs_n = 1;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 128, Check Result Bit 14 (Expected: 1)", test_num);
            reset_dut();
            cs_n = 0;
            send_byte(8'h80);

            repeat(10) @(posedge sclk);
            #2 #1;
 check_outputs(1'b1);
            cs_n = 1;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 16, Check Result Bit 8 (Expected: 1)", test_num);
            reset_dut();
            cs_n = 0;
            send_byte(8'h10);

            repeat(16) @(posedge sclk);
            #2 #1;
 check_outputs(1'b1);
            cs_n = 1;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 255, Check Result Bit 23 (Expected: 0)", test_num);
            reset_dut();
            cs_n = 0;
            send_byte(8'hFF);

            repeat(1) @(posedge sclk);
            #2 #1;
 check_outputs(1'b0);
            cs_n = 1;
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
        input expected_sdo;
        begin
            if (expected_sdo === (expected_sdo ^ sdo ^ expected_sdo)) begin
                $display("PASS");
                $display("  Outputs: sdo=%b",
                         sdo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sdo=%b",
                         expected_sdo);
                $display("  Got:      sdo=%b",
                         sdo);
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
        $dumpvars(0,cs_n, reset_n, sclk, sdi, sdo);
    end

endmodule
