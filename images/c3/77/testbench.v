`timescale 1ns/1ps

module d_ff_with_async_set_clear_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg D;
    reg SET;
    wire Q;
    wire Q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_ff_with_async_set_clear dut (
        .CLK(CLK),
        .CLR(CLR),
        .D(D),
        .SET(SET),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SET = 0;
            CLR = 1;
            D = 0;
            #(10);
            CLR = 0;
            #(10);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous SET Assertion", test_num);
            reset_dut();
            SET = 1;
            #(2);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous CLR Assertion", test_num);
            reset_dut();

            SET = 1; #5; SET = 0; #5;
            CLR = 1;
            #(2);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load High (D=1)", test_num);
            reset_dut();
            D = 1;
            SET = 0;
            CLR = 0;
            @(posedge CLK);
            #(2);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load Low (D=0)", test_num);
            reset_dut();

            D = 1;
            @(posedge CLK);
            #(2);
            D = 0;
            @(posedge CLK);
            #(2);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SET Override Mid-Cycle", test_num);
            reset_dut();
            D = 0;
            @(posedge CLK);
            #(2);

            SET = 1;
            #(2);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CLR Override Mid-Cycle", test_num);
            reset_dut();
            D = 1;
            @(posedge CLK);
            #(2);

            CLR = 1;
            #(2);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stability Between Edges", test_num);
            reset_dut();
            D = 1;
            @(posedge CLK);
            #(2);
            D = 0;
            #(2);
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
        $display("d_ff_with_async_set_clear Testbench");
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
        input expected_Q_bar;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_bar === (expected_Q_bar ^ Q_bar ^ expected_Q_bar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_bar=%b",
                         Q, Q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_bar=%b",
                         expected_Q, expected_Q_bar);
                $display("  Got:      Q=%b, Q_bar=%b",
                         Q, Q_bar);
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
        $dumpvars(0,CLK, CLR, D, SET, Q, Q_bar);
    end

endmodule
