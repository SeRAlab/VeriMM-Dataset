`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    reg reset;
    wire Qn;
    wire QnBar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .J(J),
        .K(K),
        .clk(clk),
        .reset(reset),
        .Qn(Qn),
        .QnBar(QnBar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        J = 0;
        K = 0;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Set Operation (J=1, K=0)", test_num);
        reset_dut();
        @(posedge clk);
        #1 J = 1; K = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Reset Operation (J=0, K=1)", test_num);
        reset_dut();

        @(posedge clk);
        #1 J = 1; K = 0;
        @(posedge clk);

        #1 J = 0; K = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Hold Operation (J=0, K=0) from HIGH", test_num);
        reset_dut();
        @(posedge clk);
        #1 J = 1; K = 0;
        @(posedge clk);
        #1 J = 0; K = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Hold Operation (J=0, K=0) from LOW", test_num);
        reset_dut();
        @(posedge clk);
        #1 J = 0; K = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Toggle Operation (J=1, K=1) 0->1", test_num);
        reset_dut();
        @(posedge clk);
        #1 J = 1; K = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Toggle Operation (J=1, K=1) 0->1->0", test_num);
        reset_dut();
        @(posedge clk);
        #1 J = 1; K = 1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Asynchronous Reset Override", test_num);
        reset_dut();
        @(posedge clk);
        #1 J = 1; K = 0;
        @(posedge clk);
        #1;

        #2 reset = 1;
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
        reset = 0;
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Complementary Output Check", test_num);
        reset_dut();
        @(posedge clk);
        #1 J = 1; K = 0;
        @(posedge clk);
        #1;

        if (Qn !== ~QnBar) begin
            $display("FAIL: Outputs are not complementary!");
            fail_count = fail_count + 1;
        end else begin
            #1;

            check_outputs(1'b1, 1'b0);
        end
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
        testcase008();
        
        
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
        input expected_Qn;
        input expected_QnBar;
        begin
            if (expected_Qn === (expected_Qn ^ Qn ^ expected_Qn) &&
                expected_QnBar === (expected_QnBar ^ QnBar ^ expected_QnBar)) begin
                $display("PASS");
                $display("  Outputs: Qn=%b, QnBar=%b",
                         Qn, QnBar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Qn=%b, QnBar=%b",
                         expected_Qn, expected_QnBar);
                $display("  Got:      Qn=%b, QnBar=%b",
                         Qn, QnBar);
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
        $dumpvars(0,J, K, clk, reset, Qn, QnBar);
    end

endmodule
