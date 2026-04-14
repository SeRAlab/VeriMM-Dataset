`timescale 1ns/1ps

module SR_FlipFlop_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg R;
    reg S;
    wire Q;
    wire Qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SR_FlipFlop dut (
        .CLK(CLK),
        .R(R),
        .S(S),
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
            S <= 0;
            R <= 1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Set (S=1, R=0)", test_num);
            reset_dut();
            S <= 1;
            R <= 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reset (S=0, R=1)", test_num);
            reset_dut();

            S <= 1;
            R <= 0;
            @(posedge CLK);
            #1;

            S <= 0;
            R <= 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Hold (S=0, R=0 after Set)", test_num);
            reset_dut();
            S <= 1;
            R <= 0;
            @(posedge CLK);
            #1;
            S <= 0;
            R <= 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Hold (S=0, R=0 after Reset)", test_num);
            reset_dut();
            S <= 0;
            R <= 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Invalid State (S=1, R=1)", test_num);
            reset_dut();

            S <= 1;
            R <= 0;
            @(posedge CLK);
            #1;

            S <= 1;
            R <= 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sequential Transitions (Set->Hold->Reset->Hold)", test_num);
            reset_dut();

            S <= 1; R <= 0; @(posedge CLK); #1;
            S <= 0; R <= 0; @(posedge CLK); #1;
            S <= 0; R <= 1; @(posedge CLK); #1;
            S <= 0; R <= 0; @(posedge CLK); #1;

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
        $display("SR_FlipFlop Testbench");
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
        input expected_Qbar;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qbar === (expected_Qbar ^ Qbar ^ expected_Qbar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qbar=%b",
                         Q, Qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qbar=%b",
                         expected_Q, expected_Qbar);
                $display("  Got:      Q=%b, Qbar=%b",
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
        $dumpvars(0,CLK, R, S, Q, Qbar);
    end

endmodule
