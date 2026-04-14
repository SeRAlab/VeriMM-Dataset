`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR_B;
    reg D;
    reg SET_B;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR_B(CLR_B),
        .D(D),
        .SET_B(SET_B),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            D = 0;
            SET_B = 1;
            CLR_B = 0;
            #10;
            CLR_B = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Clear", test_num);

            D = 1;
            SET_B = 1;
            CLR_B = 0;
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Set", test_num);

            D = 0;
            CLR_B = 1;
            SET_B = 0;
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load High (D=1)", test_num);

            SET_B = 1;
            CLR_B = 1;
            D = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            SET_B = 1; CLR_B = 1; D = 1;
            @(posedge CLK);
            #5;

            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load Low (D=0)", test_num);

            D = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Edge Triggering Check", test_num);

            SET_B = 1;
            CLR_B = 1;
            D = 1;
            @(negedge CLK);
            D = 1;
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Async Clear Overriding Clocked Data", test_num);

            SET_B = 1;
            CLR_B = 1;
            D = 1;
            @(posedge CLK);
            #2;

            CLR_B = 0;
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Async Set Overriding Clocked Data", test_num);

            SET_B = 1;
            CLR_B = 1;
            D = 0;
            @(posedge CLK);
            #2;

            SET_B = 0;
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
        input expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%b, Q_N=%b",
                         Q, Q_N);
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
        $dumpvars(0,CLK, CLR_B, D, SET_B, Q, Q_N);
    end

endmodule
