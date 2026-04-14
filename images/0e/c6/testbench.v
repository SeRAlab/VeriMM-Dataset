`timescale 1ns/1ps

module SR_FF_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg R;
    reg S;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SR_FF dut (
        .CLK(CLK),
        .R(R),
        .S(S),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            R = 1;
            S = 0;
            #12;
            R = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Initial State after Reset", test_num);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Set Q to 1 (S=1, R=0)", test_num);
            S = 1;
            R = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Q at 1 (S=0, R=0)", test_num);

            S = 1; R = 0;
            @(posedge CLK);
            #2;

            S = 0; R = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Q to 0 (S=0, R=1)", test_num);

            S = 1; R = 0;
            @(posedge CLK);
            #2;

            S = 0; R = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Q at 0 (S=0, R=0)", test_num);
            S = 0; R = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Triggered Mid-Cycle", test_num);

            S = 1; R = 0;
            @(posedge CLK);
            #2;

            R = 1;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Conflict Case (S=1, R=1)", test_num);
            S = 1;
            R = 1;
            @(posedge CLK);
            #2;


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
        $display("SR_FF Testbench");
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
        $dumpvars(0,CLK, R, S, Q);
    end

endmodule
