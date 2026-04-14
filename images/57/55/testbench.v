`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg en;
    reg r;
    wire [2:0] q1;
    wire [1:0] q2;
    wire [1:0] q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .en(en),
        .r(r),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            r = 1;
            en = 0;
            #15;
            r = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying initial reset state", test_num);
            reset_dut();
            #1;

            check_outputs(3'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Incrementing counter 5 times", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge c);
            #1;


            #1;



            check_outputs(3'd5, 2'd0, 2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying enable signal", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge c);
            en = 0;
            repeat(4) @(posedge c);
            #1;

            #1;


            check_outputs(3'd3, 2'd0, 2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transition from q1 to q2 (Count=11)", test_num);
            reset_dut();
            en = 1;
            repeat(11) @(posedge c);
            #1;




            #1;





            check_outputs(3'd3, 2'd1, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Transition to q3 segment (Count=50)", test_num);
            reset_dut();
            en = 1;
            repeat(50) @(posedge c);
            #1;




            #1;





            check_outputs(3'd2, 2'd2, 2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying counter rollover (128 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(128) @(posedge c);
            #1;

            #1;


            check_outputs(3'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Asynchronous reset during operation", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(posedge c);
            #2;
            r = 1;
            #1;
            #1;

            check_outputs(3'd0, 2'd0, 2'd0);
            r = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Maximum counter value (Count=127)", test_num);
            reset_dut();
            en = 1;
            repeat(127) @(posedge c);
            #1;




            #1;





            check_outputs(3'd7, 2'd3, 2'd3);
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
        input [2:0] expected_q1;
        input [1:0] expected_q2;
        input [1:0] expected_q3;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_q3 === (expected_q3 ^ q3 ^ expected_q3)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h, q3=%h",
                         q1, q2, q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h, q3=%h",
                         expected_q1, expected_q2, expected_q3);
                $display("  Got:      q1=%h, q2=%h, q3=%h",
                         q1, q2, q3);
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
        $dumpvars(0,c, en, r, q1, q2, q3);
    end

endmodule
