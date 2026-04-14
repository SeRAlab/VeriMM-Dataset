`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg Ai;
    reg Ar;
    reg [7:0] B;
    reg Bi;
    reg Br;
    reg So;
    reg clk;
    reg sub;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Ai(Ai),
        .Ar(Ar),
        .B(B),
        .Bi(Bi),
        .Br(Br),
        .So(So),
        .clk(clk),
        .sub(sub),
        .S(S)
    );
    task reset_signals;

        begin
            A = 0; Ai = 0; Ar = 1;
            B = 0; Bi = 0; Br = 1;
            So = 0; sub = 0;
            @(posedge clk);
            #1;
            Ar = 0; Br = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Reset and zero check...");
            reset_signals();
            So = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Addition (10 + 20)...");
            reset_signals();
            Ai = 1; Bi = 1; A = 8'd10; B = 8'd20; sub = 0; So = 1;
            @(posedge clk);
            Ai = 0; Bi = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Basic Subtraction (50 - 20)...");
            reset_signals();
            Ai = 1; Bi = 1; A = 8'd50; B = 8'd20; sub = 1; So = 1;
            @(posedge clk);
            Ai = 0; Bi = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: So signal control (Output zeroing)...");
            reset_signals();
            Ai = 1; Bi = 1; A = 8'd15; B = 8'd15; sub = 0; So = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Input Enable check...");
            reset_signals();

            Ai = 1; Bi = 1; A = 8'd5; B = 8'd5; sub = 0; So = 1;
            @(posedge clk);

            Ai = 0; Bi = 0; A = 8'd100; B = 8'd100;
            @(posedge clk);

            #1;


            check_outputs(8'd10);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Subtraction Underflow (5 - 10)...");
            reset_signals();
            Ai = 1; Bi = 1; A = 8'd5; B = 8'd10; sub = 1; So = 1;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Addition Overflow (250 + 10)...");
            reset_signals();
            Ai = 1; Bi = 1; A = 8'd250; B = 8'd10; sub = 0; So = 1;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Individual Reset signals...");
            reset_signals();

            Ai = 1; Bi = 1; A = 8'd50; B = 8'd50; sub = 0; So = 1;
            @(posedge clk);

            Ai = 0; Bi = 0; Ar = 1;
            @(posedge clk);
            Ar = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd50);
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
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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

endmodule
