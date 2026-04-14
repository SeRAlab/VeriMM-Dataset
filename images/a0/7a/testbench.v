`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg LOAD;
    reg SHIFT;
    wire [3:0] Q;
    wire [3:0] Qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .SHIFT(SHIFT),
        .Q(Q),
        .Qbar(Qbar)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 0;
            SHIFT = 0;
            D = 4'b0000;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Load Data 4'b1010", test_num);
            D = 4'b1010;
            LOAD = 1;
            SHIFT = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'b1010, 4'b0101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Load 4'b1101 and Shift Left Once", test_num);

            D = 4'b1101;
            LOAD = 1;
            SHIFT = 0;
            @(posedge CLK);
            #1;

            LOAD = 0;
            SHIFT = 1;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(4'b1010, 4'b0101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Load 4'b1111 and Shift Left Twice", test_num);

            D = 4'b1111;
            LOAD = 1;
            SHIFT = 0;
            @(posedge CLK);
            #1;

            LOAD = 0;
            SHIFT = 1;
            @(posedge CLK);
            #1;

            @(posedge CLK);
            #2;


            #1;



            check_outputs(4'b1100, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Simultaneous LOAD and SHIFT (Verify LOAD priority)", test_num);
            D = 4'b0110;
            LOAD = 1;
            SHIFT = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(4'b0110, 4'b1001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Shift 4 times until contents are fully replaced", test_num);

            D = 4'b1001;
            LOAD = 1;
            SHIFT = 0;
            @(posedge CLK);
            #1;

            LOAD = 0;
            SHIFT = 1;
            repeat(4) @(posedge CLK);
            #2;

            #1;


            check_outputs(4'b0000, 4'b1111);
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
        input [3:0] expected_Q;
        input [3:0] expected_Qbar;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qbar === (expected_Qbar ^ Qbar ^ expected_Qbar)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Qbar=%h",
                         Q, Qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Qbar=%h",
                         expected_Q, expected_Qbar);
                $display("  Got:      Q=%h, Qbar=%h",
                         Q, Qbar);
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
        $dumpvars(0,CLK, D, LOAD, SHIFT, Q, Qbar);
    end

endmodule
