`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CIN;
    reg clk;
    wire COUT;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .clk(clk),
        .COUT(COUT),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0000;
            B = 4'b0000;
            CIN = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: 1 + 1 + 0 = 2", test_num);
            reset_dut();
            A = 4'd1;
            B = 4'd1;
            CIN = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 0 + 0 + 1 = 1", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            CIN = 1'b1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 8 + 8 + 0 = 16 (COUT=1, S=0)", test_num);
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            CIN = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 7 + 1 + 0 = 8", test_num);
            reset_dut();
            A = 4'b0111;
            B = 4'b0001;
            CIN = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 15 + 15 + 1 = 31", test_num);
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            CIN = 1'b1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 15 + 0 + 1 = 16", test_num);
            reset_dut();
            A = 4'hF;
            B = 4'h0;
            CIN = 1'b1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 10 + 5 + 0 = 15", test_num);
            reset_dut();
            A = 4'd10;
            B = 4'd5;
            CIN = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: 0 + 0 + 0 = 0", test_num);
            reset_dut();
            A = 4'h0;
            B = 4'h0;
            CIN = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h0);
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
        input expected_COUT;
        input [3:0] expected_S;
        begin
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, S=%h",
                         COUT, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, S=%h",
                         expected_COUT, expected_S);
                $display("  Got:      COUT=%b, S=%h",
                         COUT, S);
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
        $dumpvars(0,A, B, CIN, clk, COUT, S);
    end

endmodule
