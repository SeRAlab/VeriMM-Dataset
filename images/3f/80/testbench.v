`timescale 1ns/1ps

module sr_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg R;
    reg S;
    reg clk;
    reg reset;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sr_flip_flop dut (
        .R(R),
        .S(S),
        .clk(clk),
        .reset(reset),
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
        reset = 1;
        S = 0;
        R = 0;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Asynchronous Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Set Operation (S=1, R=0)", test_num);
        reset_dut();
        @(posedge clk);
        S <= 1;
        R <= 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Reset Operation (S=0, R=1)", test_num);
        reset_dut();

        @(posedge clk);
        S <= 1; R <= 0;
        @(posedge clk);

        S <= 0; R <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Hold Operation (Previous state Q=1)", test_num);
        reset_dut();

        @(posedge clk);
        S <= 1; R <= 0;
        @(posedge clk);

        S <= 0; R <= 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Hold Operation (Previous state Q=0)", test_num);
        reset_dut();

        @(posedge clk);
        S <= 0; R <= 1;
        @(posedge clk);

        S <= 0; R <= 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Asynchronous Reset Priority over Synchronous Set", test_num);
        reset_dut();
        @(posedge clk);
        S <= 1; R <= 0;
        #2;
        reset = 1;
        #2;
        #1;

        check_outputs(0, 1);
        reset = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Sequential Set then Reset", test_num);
        reset_dut();
        @(posedge clk);
        S <= 1; R <= 0;
        @(posedge clk);
        S <= 0; R <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sr_flip_flop Testbench");
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
        $dumpvars(0,R, S, clk, reset, Q, Qn);
    end

endmodule
