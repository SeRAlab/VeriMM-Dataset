`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg LD;
    reg SH;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .LD(LD),
        .SH(SH),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        LD = 0;
        forever #5 LD = ~LD;
    end

        task reset_dut;

        begin
            D = 4'b0000;
            LD = 1;
            SH = 0;
            @(posedge clk);
            #1;
            LD = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 4'b1011", test_num);
            D = 4'b1011;
            LD = 1;
            SH = 0;
            @(posedge clk);
            #1;
            LD = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 4'b1010 then Right Shift", test_num);

            D = 4'b1010; LD = 1; SH = 0;
            @(posedge clk);
            #1;

            LD = 0; SH = 1;
            @(posedge clk);
            #1;
            SH = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 4'b1000 then 3 Right Shifts", test_num);

            D = 4'b1000; LD = 1; SH = 0;
            @(posedge clk);
            #1;

            LD = 0; SH = 1;
            repeat(3) @(posedge clk);
            #1;
            SH = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 4'b0111 then Hold", test_num);

            D = 4'b0111; LD = 1; SH = 0;
            @(posedge clk);
            #1;

            LD = 0; SH = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (LD and SH high)", test_num);

            D = 4'b1111;
            LD = 1;
            SH = 1;
            @(posedge clk);
            #1;
            LD = 0; SH = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift until all zeros", test_num);

            D = 4'b0001; LD = 1; SH = 0;
            @(posedge clk);
            #1;

            LD = 0; SH = 1;
            @(posedge clk);
            #1;
            SH = 0;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, LD, SH, Q);
    end

endmodule
