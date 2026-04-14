`timescale 1ns/1ps

module InterruptController_tb;

    // Testbench signals (sequential circuit)
    reg IRQ0;
    reg IRQ1;
    reg IRQ2;
    reg RST;
    wire IRQ_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    InterruptController dut (
        .IRQ0(IRQ0),
        .IRQ1(IRQ1),
        .IRQ2(IRQ2),
        .RST(RST),
        .IRQ_OUT(IRQ_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        IRQ0 = 0;
        forever #5 IRQ0 = ~IRQ0;
    end

        task reset_dut;

        begin
            RST = 1;
            IRQ0 = 0;
            IRQ1 = 0;
            IRQ2 = 0;
            #20;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset and Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ0 Only (Highest Priority)", test_num);
            reset_dut();
            IRQ0 = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ1 Only", test_num);
            reset_dut();
            IRQ1 = 1;
            #10;
            #1;

            check_outputs(2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ2 Only", test_num);
            reset_dut();
            IRQ2 = 1;
            #10;
            #1;

            check_outputs(3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ0 and IRQ1 Simultaneous (IRQ0 should win)", test_num);
            reset_dut();
            IRQ0 = 1;
            IRQ1 = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ1 and IRQ2 Simultaneous (IRQ1 should win)", test_num);
            reset_dut();
            IRQ1 = 1;
            IRQ2 = 1;
            #10;
            #1;

            check_outputs(2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All IRQs Active (IRQ0 should win)", test_num);
            reset_dut();
            IRQ0 = 1;
            IRQ1 = 1;
            IRQ2 = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ2 active then IRQ0 arrives", test_num);
            reset_dut();
            IRQ2 = 1;
            #10;
            IRQ0 = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset activated while IRQ1 is high", test_num);
            reset_dut();
            IRQ1 = 1;
            #10;
            RST = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Releasing all interrupts", test_num);
            reset_dut();
            IRQ0 = 1;
            #10;
            IRQ0 = 0;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("InterruptController Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_IRQ_OUT;
        begin
            if (expected_IRQ_OUT === (expected_IRQ_OUT ^ IRQ_OUT ^ expected_IRQ_OUT)) begin
                $display("PASS");
                $display("  Outputs: IRQ_OUT=%b",
                         IRQ_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IRQ_OUT=%b",
                         expected_IRQ_OUT);
                $display("  Got:      IRQ_OUT=%b",
                         IRQ_OUT);
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
        $dumpvars(0,IRQ0, IRQ1, IRQ2, RST, IRQ_OUT);
    end

endmodule
