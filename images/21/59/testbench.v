`timescale 1ns/1ps

module round_robin_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg rst;
    wire gnt0;
    wire gnt1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    round_robin_arbiter dut (
        .clk(clk),
        .req0(req0),
        .req1(req1),
        .rst(rst),
        .gnt0(gnt0),
        .gnt1(gnt1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req0 = 0;
            req1 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;
            $display("Testcase 001: Reset state - No requests");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            req0 = 1;
            req1 = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Only Req0 high");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            req0 = 0;
            req1 = 1;
            @(posedge clk);
            #1;
            $display("Testcase 003: Only Req1 high");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            req0 = 1;
            req1 = 1;
            @(posedge clk);
            #1;
            $display("Testcase 004: Both high - Initial priority (Req0)");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            req0 = 1;
            req1 = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 005: Both high - Second cycle alternation (Req1)");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            req0 = 1;
            req1 = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 006: Both high - Third cycle wrap around (Req0)");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            req0 = 1; req1 = 0;
            @(posedge clk);


            req0 = 0; req1 = 1;
            @(posedge clk);
            #1;
            $display("Testcase 007: Sequential requests (Req0 then Req1)");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            req0 = 1; req1 = 1;
            @(posedge clk);
            req0 = 0; req1 = 0;
            @(posedge clk);
            #1;
            $display("Testcase 008: Request dropped - No grants");
            #1;

            check_outputs(0, 0);
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
        input expected_gnt0;
        input expected_gnt1;
        begin
            if (expected_gnt0 === (expected_gnt0 ^ gnt0 ^ expected_gnt0) &&
                expected_gnt1 === (expected_gnt1 ^ gnt1 ^ expected_gnt1)) begin
                $display("PASS");
                $display("  Outputs: gnt0=%b, gnt1=%b",
                         gnt0, gnt1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt0=%b, gnt1=%b",
                         expected_gnt0, expected_gnt1);
                $display("  Got:      gnt0=%b, gnt1=%b",
                         gnt0, gnt1);
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
        $dumpvars(0,clk, req0, req1, rst, gnt0, gnt1);
    end

endmodule
