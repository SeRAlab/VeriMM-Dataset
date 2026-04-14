`timescale 1ns/1ps

module d_ff_reset_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg RESET_B;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_ff_reset dut (
        .CLK(CLK),
        .D(D),
        .RESET_B(RESET_B),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        D = 0;
        RESET_B = 0;
        #(20);
        RESET_B = 1;
        #(5);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Power-on Reset", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Load Logic 1", test_num);
        reset_dut();
        @(posedge CLK);
        D <= 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load 1 then Load 0", test_num);
        reset_dut();
        @(posedge CLK);
        D <= 1'b1;
        @(posedge CLK);
        D <= 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Asynchronous Reset Override", test_num);
        reset_dut();
        @(posedge CLK);
        D <= 1'b1;
        @(posedge CLK);
        #1;

        RESET_B = 1'b0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data Stability (No Clock Edge)", test_num);
        reset_dut();
        @(posedge CLK);
        D <= 1'b1;
        @(posedge CLK);
        #1;

        D <= 1'b0;
        #4;
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
        $display("d_ff_reset Testbench");
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
        $dumpvars(0,CLK, D, RESET_B, Q);
    end

endmodule
