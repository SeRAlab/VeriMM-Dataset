`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg FONT5_detect;
    reg auxOutA;
    reg auxOutB;
    reg clk;
    wire auxOutA1;
    wire auxOutA2;
    wire auxOutB1;
    wire auxOutB2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FONT5_detect(FONT5_detect),
        .auxOutA(auxOutA),
        .auxOutB(auxOutB),
        .clk(clk),
        .auxOutA1(auxOutA1),
        .auxOutA2(auxOutA2),
        .auxOutB1(auxOutB1),
        .auxOutB2(auxOutB2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            FONT5_detect = 0;
            auxOutA = 0;
            auxOutB = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            FONT5_detect = 1;
            auxOutA = 0;
            auxOutB = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: FONT5_detect=1, auxOutA=0, auxOutB=1", test_num);
            #1;

            check_outputs(1'b0, 1'bz, 1'b1, 1'bz);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            FONT5_detect = 1;
            auxOutA = 1;
            auxOutB = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: FONT5_detect=1, auxOutA=1, auxOutB=0", test_num);
            #1;

            check_outputs(1'b1, 1'bz, 1'b0, 1'bz);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            FONT5_detect = 0;
            auxOutA = 0;
            auxOutB = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: FONT5_detect=0, auxOutA=0, auxOutB=0", test_num);

            #1;


            check_outputs(1'bz, 1'b1, 1'bz, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            FONT5_detect = 0;
            auxOutA = 1;
            auxOutB = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: FONT5_detect=0, auxOutA=1, auxOutB=1", test_num);

            #1;


            check_outputs(1'bz, 1'b0, 1'bz, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            FONT5_detect = 0;
            auxOutA = 1;
            auxOutB = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: FONT5_detect=0, auxOutA=1, auxOutB=0", test_num);

            #1;


            check_outputs(1'bz, 1'b0, 1'bz, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            FONT5_detect = 1;
            auxOutA = 1;
            auxOutB = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: FONT5_detect=1, auxOutA=1, auxOutB=1", test_num);
            #1;

            check_outputs(1'b1, 1'bz, 1'b1, 1'bz);
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
        input expected_auxOutA1;
        input expected_auxOutA2;
        input expected_auxOutB1;
        input expected_auxOutB2;
        begin
            if (expected_auxOutA1 === (expected_auxOutA1 ^ auxOutA1 ^ expected_auxOutA1) &&
                expected_auxOutA2 === (expected_auxOutA2 ^ auxOutA2 ^ expected_auxOutA2) &&
                expected_auxOutB1 === (expected_auxOutB1 ^ auxOutB1 ^ expected_auxOutB1) &&
                expected_auxOutB2 === (expected_auxOutB2 ^ auxOutB2 ^ expected_auxOutB2)) begin
                $display("PASS");
                $display("  Outputs: auxOutA1=%b, auxOutA2=%b, auxOutB1=%b, auxOutB2=%b",
                         auxOutA1, auxOutA2, auxOutB1, auxOutB2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: auxOutA1=%b, auxOutA2=%b, auxOutB1=%b, auxOutB2=%b",
                         expected_auxOutA1, expected_auxOutA2, expected_auxOutB1, expected_auxOutB2);
                $display("  Got:      auxOutA1=%b, auxOutA2=%b, auxOutB1=%b, auxOutB2=%b",
                         auxOutA1, auxOutA2, auxOutB1, auxOutB2);
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
        $dumpvars(0,FONT5_detect, auxOutA, auxOutB, clk, auxOutA1, auxOutA2, auxOutB1, auxOutB2);
    end

endmodule
