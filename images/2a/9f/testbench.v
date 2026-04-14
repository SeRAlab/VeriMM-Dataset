`timescale 1ns/1ps

module round_robin_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    round_robin_arbiter dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_cycle;

        begin
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            req = 4'b0001;
            wait_cycle();
            $display("Testcase 001: Single Request (Req 0)");
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            req = 4'b0100;
            wait_cycle();
            $display("Testcase 002: Single Request (Req 2)");
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            req = 4'b0101;
            wait_cycle();
            $display("Testcase 003: Multi-request after reset (0 and 2 active)");
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            req = 4'b0101;
            wait_cycle();
            wait_cycle();
            $display("Testcase 004: Round-Robin cycle between Req 0 and 2");
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            req = 4'b1111;
            wait_cycle();
            wait_cycle();
            wait_cycle();
            wait_cycle();
            $display("Testcase 005: Full rotation (All active, check last)");
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            req = 4'b1111;
            wait_cycle();
            wait_cycle();
            wait_cycle();
            wait_cycle();
            wait_cycle();
            $display("Testcase 006: Wraparound from Req 3 to Req 0");
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            req = 4'b0001;
            wait_cycle();
            req = 4'b1000;
            wait_cycle();
            $display("Testcase 007: Skipping inactive Reqs (0 then 3)");
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            req = 4'b0011;
            wait_cycle();
            req = 4'b0000;
            wait_cycle();
            $display("Testcase 008: All requests released (Idle)");
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            req = 4'b0001;
            wait_cycle();
            req = 4'b0011;
            wait_cycle();
            $display("Testcase 009: Persistent Req 0 loses priority to Req 1");
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            req = 4'b0100;
            wait_cycle();
            req = 4'b1010;
            wait_cycle();
            wait_cycle();
            $display("Testcase 010: Complex sequence (Grant 2 -> 3 -> 1)");
            #1;

            check_outputs(4'b0010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("round_robin_arbiter Testbench");
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
        input [3:0] expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%h",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h",
                         expected_grant);
                $display("  Got:      grant=%h",
                         grant);
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
        $dumpvars(0,clk, req, rst, grant);
    end

endmodule
