`timescale 1ns/1ps

module SR_FF_tb;

    // Testbench signals (sequential circuit)
    reg R;
    reg S;
    reg clk;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SR_FF dut (
        .R(R),
        .S(S),
        .clk(clk),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            S <= 0;
            R <= 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Set Operation (S=1, R=0)", test_num);
            reset_dut();

            S <= 1;
            R <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Operation (S=0, R=1)", test_num);
            reset_dut();


            S <= 1; R <= 0; @(posedge clk);


            S <= 0;
            R <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Operation After Set (S=0, R=0)", test_num);
            reset_dut();


            S <= 1; R <= 0; @(posedge clk);


            S <= 0;
            R <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Operation After Reset (S=0, R=0)", test_num);
            reset_dut();


            S <= 0; R <= 1; @(posedge clk);


            S <= 0;
            R <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Undefined State (S=1, R=1)", test_num);
            reset_dut();

            S <= 1;
            R <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'bx, 1'bx);
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
        input expected_Qn;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qn=%b",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qn=%b",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%b, Qn=%b",
                         Q, Qn);
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
        $dumpvars(0,R, S, clk, Q, Qn);
    end

endmodule
