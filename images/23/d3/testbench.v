`timescale 1ns/1ps

module T_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg T;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    T_latch dut (
        .CLK(CLK),
        .T(T),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLK = 0;
            T = 0;
            #10;


            $display("Status: Resetting DUT inputs...");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: CLK=1, T=0 (Hold)", test_num);
            reset_dut();
            @(posedge CLK);
            T = 0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: CLK=1, T=1 (Toggle 0->1)", test_num);
            reset_dut();
            @(posedge CLK);
            T = 1;
            #2;
            T = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: CLK=1, Two T Pulses (Toggle 0->1->0)", test_num);
            reset_dut();
            @(posedge CLK);

            T = 1; #2; T = 0; #2;

            T = 1; #2; T = 0; #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: CLK=0, T=1 (Latch Hold)", test_num);
            reset_dut();
            @(negedge CLK);
            T = 1;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Toggle while High, then hold while Low", test_num);
            reset_dut();

            @(posedge CLK);
            T = 1; #2; T = 0;

            @(negedge CLK);
            T = 1;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple T pulses during one High Clock cycle", test_num);
            reset_dut();
            @(posedge CLK);
            repeat(3) begin
                T = 1; #1; T = 0; #1;
            end

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
        $display("T_latch Testbench");
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
        $dumpvars(0,CLK, T, Q);
    end

endmodule
