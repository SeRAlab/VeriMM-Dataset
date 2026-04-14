`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg d;
    reg sd;
    reg se;
    wire q_l;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .d(d),
        .sd(sd),
        .se(se),
        .q_l(q_l),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            d = 0;
            sd = 0;
            se = 0;
            @(posedge ck);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Normal Data Load (d=1, se=0)", test_num);
            d = 1;
            se = 0;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Normal Data Load (d=0, se=0)", test_num);

            d = 0;
            se = 0;

            d = 1; @(posedge ck); #1;
            d = 0;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Scan Data Load (sd=1, se=1)", test_num);
            sd = 1;
            se = 1;
            d = 0;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Scan Data Load (sd=0, se=1)", test_num);

            sd = 1; se = 1; @(posedge ck); #1;
            sd = 0;
            se = 1;
            d = 1;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Scan Enable Priority (se=1, sd=1, d=0)", test_num);
            se = 1;
            sd = 1;
            d = 0;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Scan Enable Priority (se=1, sd=0, d=1)", test_num);

            d = 1; se = 0; @(posedge ck); #1;
            se = 1;
            sd = 0;
            d = 1;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_q_l;
        input expected_so;
        begin
            if (expected_q_l === (expected_q_l ^ q_l ^ expected_q_l) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: q_l=%b, so=%b",
                         q_l, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_l=%b, so=%b",
                         expected_q_l, expected_so);
                $display("  Got:      q_l=%b, so=%b",
                         q_l, so);
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
        $dumpvars(0,ck, d, sd, se, q_l, so);
    end

endmodule
