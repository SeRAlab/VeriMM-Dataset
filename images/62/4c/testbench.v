`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] S;
    reg clk;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .clk(clk),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A <= 16'h0;
            B <= 16'h0;
            S <= 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select A (S=0000)", test_num);
            A <= 16'hAAAA;
            B <= 16'h5555;
            S <= 4'b0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select B (S=1111)", test_num);
            A <= 16'hAAAA;
            B <= 16'h5555;
            S <= 4'b1111;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift A left by 1 (S=0001)", test_num);
            A <= 16'h8001;
            B <= 16'h0000;
            S <= 4'b0001;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift A left by 4 (S=0100)", test_num);
            A <= 16'h000F;
            B <= 16'h0000;
            S <= 4'b0100;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift A left by 7 (S=0111)", test_num);
            A <= 16'h00FF;
            B <= 16'h0000;
            S <= 4'b0111;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7F80);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift B right by 0 (S=1000)", test_num);
            A <= 16'h0000;
            B <= 16'hF00F;
            S <= 4'b1000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF00F);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift B right by 2 (S=1010)", test_num);
            A <= 16'h0000;
            B <= 16'hF00F;
            S <= 4'b1010;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3C03);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift B right by 6 (S=1110)", test_num);
            A <= 16'h0000;
            B <= 16'hFFFF;
            S <= 4'b1110;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h03FF);
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
        input [15:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, B, S, clk, Y);
    end

endmodule
