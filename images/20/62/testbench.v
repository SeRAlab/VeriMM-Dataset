`timescale 1ns/1ps

module MasterSlaveDLatch_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg E;
    wire Q;
    wire Q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MasterSlaveDLatch dut (
        .D(D),
        .E(E),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        E = 0;
        forever #5 E = ~E;
    end

        task reset_dut;

    begin
        D = 0;

        wait(E == 1);
        #2;
        D = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transparent Mode - Setting Q to 1", test_num);
        reset_dut();

        @(posedge E);
        #2;
        D = 1;
        #2;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Latching Mode - Holding 1", test_num);
        reset_dut();

        @(posedge E);
        #2;
        D = 1;
        @(negedge E);
        #2;
        D = 0;
        #2;


        #1;



        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Latching Mode - Holding 0", test_num);
        reset_dut();

        @(posedge E);
        #2;
        D = 0;
        @(negedge E);
        #2;
        D = 1;
        #2;


        #1;



        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transparent Mode - Multiple transitions", test_num);
        reset_dut();

        @(posedge E);
        #1; D = 1;
        #1; D = 0;
        #1; D = 1;
        #1; D = 0;
        #1;


        #1;



        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Timing - Change D right before E falls", test_num);
        reset_dut();

        @(posedge E);
        #2;
        D = 0;
        #1;
        wait(E == 0);
        D = 1;
        #2;


        #1;



        check_outputs(1'b0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MasterSlaveDLatch Testbench");
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
        $dumpvars(0,D, E, Q, Q_bar);
    end

endmodule
