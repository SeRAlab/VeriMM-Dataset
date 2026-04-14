`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr1;
    reg [3:0] addr2;
    reg clk1;
    reg clk2;
    reg [7:0] data1;
    reg [7:0] data2;
    reg re1;
    reg re2;
    reg we1;
    reg we2;
    wire [7:0] q1;
    wire [7:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk1(clk1),
        .clk2(clk2),
        .data1(data1),
        .data2(data2),
        .re1(re1),
        .re2(re2),
        .we1(we1),
        .we2(we2),
        .q1(q1),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        clk1 = 0;
        forever #5 clk1 = ~clk1;
    end

        task reset_dut;

        begin
            addr1 = 0; addr2 = 0;
            data1 = 0; data2 = 0;
            re1 = 0; re2 = 0;
            we1 = 0; we2 = 0;
            repeat(2) @(posedge clk1);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk1);
            addr1 = 4'h4; data1 = 8'hA5; we1 = 1;
            @(posedge clk1);
            we1 = 0;

            addr1 = 4'h4; re1 = 1;
            @(posedge clk1);
            re1 = 0;
            #1;
            $display("Testcase 001: Port 1 Basic Write/Read");
            #1;

            check_outputs(8'hA5, 8'hzz);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clk2);
            addr2 = 4'hC; data2 = 8'h5A; we2 = 1;
            @(posedge clk2);
            we2 = 0;

            addr2 = 4'hC; re2 = 1;
            @(posedge clk2);
            re2 = 0;
            #1;
            $display("Testcase 002: Port 2 Basic Write/Read");
            #1;

            check_outputs(8'hzz, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            fork
                begin
                    @(posedge clk1);
                    addr1 = 4'h1; data1 = 8'h11; we1 = 1;
                    @(posedge clk1);
                    we1 = 0;
                end
                begin
                    @(posedge clk2);
                    addr2 = 4'h2; data2 = 8'h22; we2 = 1;
                    @(posedge clk2);
                    we2 = 0;
                end
            join

            fork
                begin
                    @(posedge clk1);
                    addr1 = 4'h2; re1 = 1;
                    @(posedge clk1);
                    re1 = 0;
                end
                begin
                    @(posedge clk2);
                    addr2 = 4'h1; re2 = 1;
                    @(posedge clk2);
                    re2 = 0;
                end
            join
            #1;
            $display("Testcase 003: Simultaneous Port Operations");
            #1;

            check_outputs(8'h22, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk1);
            addr1 = 4'h7; data1 = 8'h77; we1 = 1;
            @(posedge clk1);
            we1 = 0;

            @(posedge clk2);
            addr2 = 4'h7; re2 = 1;
            @(posedge clk2);
            re2 = 0;
            #1;
            $display("Testcase 004: Cross-port Write-then-Read (Addr 7)");
            #1;

            check_outputs(8'hzz, 8'h77);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge clk1);
            addr1 = 4'hF; data1 = 8'hFF; we1 = 1;
            @(posedge clk1);
            we1 = 0;

            addr1 = 4'hF; re1 = 0;
            @(posedge clk1);
            #1;
            $display("Testcase 005: Read Enable Inactive Check");


            if (q1 !== 8'hFF) begin
                pass_count = pass_count + 1;
                $display("PASS: q1 did not update to 0xFF without re1");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: q1 updated despite re1 being low");
            end
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
        input [7:0] expected_q1;
        input [7:0] expected_q2;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h",
                         q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h",
                         expected_q1, expected_q2);
                $display("  Got:      q1=%h, q2=%h",
                         q1, q2);
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
        $dumpvars(0,addr1, addr2, clk1, clk2, data1, data2, re1, re2, we1, we2, q1, q2);
    end

endmodule
