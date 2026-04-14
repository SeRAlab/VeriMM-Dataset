`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg PL;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .PL(PL),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            PL = 1;
            D = 4'b0000;
            @(negedge CLK);
            PL = 0;
            D = 4'b0000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge CLK);
            PL = 1;
            D = 4'b1011;
            @(posedge CLK);
            #2;
            $display("Testcase %0d: Parallel Load 1011", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge CLK);
            PL = 1; D = 4'b1011;
            @(negedge CLK);
            PL = 0;
            @(posedge CLK);
            #2;
            $display("Testcase %0d: Rotate Right 1011 once -> 1101", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge CLK);
            PL = 1; D = 4'b1011;
            @(negedge CLK);
            PL = 0;
            repeat(2) @(posedge CLK);
            #2;
            $display("Testcase %0d: Rotate Right 1011 twice -> 1110", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge CLK);
            PL = 1; D = 4'b1011;
            @(negedge CLK);
            PL = 0;
            repeat(3) @(posedge CLK);
            #2;
            $display("Testcase %0d: Rotate Right 1011 three times -> 0111", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge CLK);
            PL = 1; D = 4'b1011;
            @(negedge CLK);
            PL = 0;
            repeat(4) @(posedge CLK);
            #2;
            $display("Testcase %0d: Rotate Right 1011 four times -> 1011", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge CLK);
            PL = 1; D = 4'b1000;
            @(negedge CLK);
            PL = 0;
            repeat(3) @(posedge CLK);
            #2;
            $display("Testcase %0d: Rotate 1000 three times -> 0001", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge CLK);
            PL = 1; D = 4'b1110;
            @(posedge CLK);
            #2;
            $display("Testcase %0d: Parallel Load 1110", test_num);
            #1;

            check_outputs(1'b0);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,CLK, D, PL, Q);
    end

endmodule
