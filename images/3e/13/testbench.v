`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg r0;
    reg r1;
    reg r2;
    reg r3;
    reg rst;
    wire g0;
    wire g1;
    wire g2;
    wire g3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .r0(r0),
        .r1(r1),
        .r2(r2),
        .r3(r3),
        .rst(rst),
        .g0(g0),
        .g1(g1),
        .g2(g2),
        .g3(g3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            r0 = 0; r1 = 0; r2 = 0; r3 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Request r0", test_num);
            reset_dut();
            r0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Requests Simultaneous", test_num);
            reset_dut();
            r0 = 1; r1 = 1; r2 = 1; r3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Locking (r2 held, higher priority r0 arrives)", test_num);
            reset_dut();
            r2 = 1;
            @(posedge clk);
            #1;
            r0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Handover (r2 releases, r0 takes over)", test_num);
            reset_dut();
            r2 = 1;
            @(posedge clk);
            #1;
            r0 = 1;
            @(posedge clk);
            #1;
            r2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multi-stage Handover (r1 releases to r2)", test_num);
            reset_dut();
            r1 = 1; r2 = 1; r3 = 1;
            @(posedge clk);
            #1;
            r1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Release to Idle", test_num);
            reset_dut();
            r3 = 1;
            @(posedge clk);
            #1;
            r3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-Priority (r1 vs r2)", test_num);
            reset_dut();
            r1 = 1; r2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
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
        input expected_g0;
        input expected_g1;
        input expected_g2;
        input expected_g3;
        begin
            if (expected_g0 === (expected_g0 ^ g0 ^ expected_g0) &&
                expected_g1 === (expected_g1 ^ g1 ^ expected_g1) &&
                expected_g2 === (expected_g2 ^ g2 ^ expected_g2) &&
                expected_g3 === (expected_g3 ^ g3 ^ expected_g3)) begin
                $display("PASS");
                $display("  Outputs: g0=%b, g1=%b, g2=%b, g3=%b",
                         g0, g1, g2, g3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g0=%b, g1=%b, g2=%b, g3=%b",
                         expected_g0, expected_g1, expected_g2, expected_g3);
                $display("  Got:      g0=%b, g1=%b, g2=%b, g3=%b",
                         g0, g1, g2, g3);
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
        $dumpvars(0,clk, r0, r1, r2, r3, rst, g0, g1, g2, g3);
    end

endmodule
