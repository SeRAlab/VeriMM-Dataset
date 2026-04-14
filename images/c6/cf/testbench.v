`timescale 1ns/1ps

module D_ff_with_ce_and_synch_reset_behavior_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg D;
    reg ce;
    reg reset;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    D_ff_with_ce_and_synch_reset_behavior dut (
        .Clk(Clk),
        .D(D),
        .ce(ce),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            D = 0;
            ce = 0;
            reset = 1;
            @(posedge Clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge Clk);
            #1;
            $display("Test %0d: Synchronous Reset", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            D = 1;
            ce = 1;
            @(posedge Clk);
            #1;
            $display("Test %0d: Load Data 1 (ce=1, D=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            D = 1; ce = 1;
            @(posedge Clk);

            D = 0; ce = 1;
            @(posedge Clk);
            #1;
            $display("Test %0d: Load Data 0 (ce=1, D=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            D = 1; ce = 1;
            @(posedge Clk);

            D = 0; ce = 0;
            @(posedge Clk);
            #1;
            $display("Test %0d: Clock Enable Low (Holding Q=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            D = 1; ce = 1;
            @(posedge Clk);

            reset = 1; D = 1; ce = 1;
            @(posedge Clk);
            #1;
            reset = 0;
            $display("Test %0d: Reset priority over Enable and Data", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ce = 1;
            D = 1;
            #2;
            D = 0;
            #1;
            $display("Test %0d: Data change mid-cycle (should not affect Q yet)", test_num);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ce = 1;
            D = 1; @(posedge Clk);
            D = 0; @(posedge Clk);
            D = 1; @(posedge Clk);
            #1;
            $display("Test %0d: Sequential Toggling", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("D_ff_with_ce_and_synch_reset_behavior Testbench");
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
        $dumpvars(0,Clk, D, ce, reset, Q);
    end

endmodule
