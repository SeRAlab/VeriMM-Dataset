`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [10:0] D;
    reg POP;
    reg PUSH;
    reg RESET;
    wire [10:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .POP(POP),
        .PUSH(PUSH),
        .RESET(RESET),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            PUSH = 0;
            POP = 0;
            D = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Push and Pop", test_num);
            reset_dut();


            PUSH = 1; D = 11'h1A5;
            @(posedge CLK); #1;
            PUSH = 0;


            POP = 1;
            @(posedge CLK); #1;
            POP = 0;

            #1;


            check_outputs(11'h1A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Top of Stack (LIFO)", test_num);
            reset_dut();


            PUSH = 1; D = 11'h111;
            @(posedge CLK); #1;

            PUSH = 1; D = 11'h222;
            @(posedge CLK); #1;
            PUSH = 0;


            POP = 1;
            @(posedge CLK); #1;
            POP = 0;

            #1;


            check_outputs(11'h222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Full LIFO Order", test_num);
            reset_dut();


            PUSH = 1; D = 11'hAAA;
            @(posedge CLK); #1;
            PUSH = 1; D = 11'hBBB;
            @(posedge CLK); #1;
            PUSH = 0;


            POP = 1;
            @(posedge CLK); #1;

            POP = 1;
            @(posedge CLK); #1;
            POP = 0;

            #1;


            check_outputs(11'hAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Deeper Stack Operation", test_num);
            reset_dut();


            PUSH = 1; D = 11'h010; @(posedge CLK); #1;
            PUSH = 1; D = 11'h020; @(posedge CLK); #1;
            PUSH = 1; D = 11'h030; @(posedge CLK); #1;
            PUSH = 1; D = 11'h040; @(posedge CLK); #1;
            PUSH = 0;


            POP = 1; @(posedge CLK); #1;
            POP = 1; @(posedge CLK); #1;
            POP = 1; @(posedge CLK); #1;
            POP = 0;

            #1;


            check_outputs(11'h020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved Push/Pop", test_num);
            reset_dut();

            PUSH = 1; D = 11'h701; @(posedge CLK); #1;
            PUSH = 1; D = 11'h702; @(posedge CLK); #1;
            PUSH = 0; POP = 1;      @(posedge CLK); #1;
            POP = 0; PUSH = 1; D = 11'h703; @(posedge CLK); #1;
            PUSH = 0; POP = 1;      @(posedge CLK); #1;
            POP = 1;                @(posedge CLK); #1;
            POP = 0;

            #1;


            check_outputs(11'h701);
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
        input [10:0] expected_Q;
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
        $dumpvars(0,CLK, D, POP, PUSH, RESET, Q);
    end

endmodule
