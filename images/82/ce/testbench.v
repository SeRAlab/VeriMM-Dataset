`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg [7:0] q1;
    reg rst_n;
    wire [7:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .q1(q1),
        .rst_n(rst_n),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            rst_n = 0;
            q1 = 8'h00;
            @(negedge ck);
            rst_n = 1;
            @(negedge ck);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying reset state...", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Loading 8'hA5...", test_num);
            reset_dut();
            q1 = 8'hA5;
            @(posedge ck);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Loading 8'h5A...", test_num);
            reset_dut();
            q1 = 8'h5A;
            @(posedge ck);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Loading 8'hFF...", test_num);
            reset_dut();
            q1 = 8'hFF;
            @(posedge ck);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying data doesn't change on negative edge...", test_num);
            reset_dut();
            q1 = 8'hCC;
            @(posedge ck);
            #2;
            q1 = 8'h33;
            @(negedge ck);
            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive data loads...", test_num);
            reset_dut();
            q1 = 8'h11; @(posedge ck); #1;
            q1 = 8'h22; @(posedge ck); #1;
            q1 = 8'h33; @(posedge ck); #1;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_q2;
        begin
            if (expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q2=%h",
                         q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q2=%h",
                         expected_q2);
                $display("  Got:      q2=%h",
                         q2);
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
        $dumpvars(0,ck, q1, rst_n, q2);
    end

endmodule
