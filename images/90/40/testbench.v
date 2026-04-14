`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg clk;
    wire EN;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .clk(clk),
        .EN(EN),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0;
            B = 4'b0;
            C = 4'b0;
            D = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            @(posedge clk);
            #1;
            $display("Test %0d: All inputs inactive", test_num);
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'hA; B = 4'h0; C = 4'h0; D = 4'h0;
            @(posedge clk);
            #1;
            $display("Test %0d: Input A active", test_num);
            #1;

            check_outputs(1'b1, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h0; B = 4'hB; C = 4'h0; D = 4'h0;
            @(posedge clk);
            #1;
            $display("Test %0d: Input B active", test_num);
            #1;

            check_outputs(1'b1, 4'hB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h0; B = 4'h0; C = 4'hC; D = 4'h0;
            @(posedge clk);
            #1;
            $display("Test %0d: Input C active", test_num);
            #1;

            check_outputs(1'b1, 4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'hD;
            @(posedge clk);
            #1;
            $display("Test %0d: Input D active", test_num);
            #1;

            check_outputs(1'b1, 4'hD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h1; B = 4'h0; C = 4'h0; D = 4'hF;
            @(posedge clk);
            #1;
            $display("Test %0d: Priority D over A", test_num);
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h0; B = 4'h2; C = 4'hE; D = 4'h0;
            @(posedge clk);
            #1;
            $display("Test %0d: Priority C over B", test_num);
            #1;

            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h7; B = 4'h3; C = 4'h0; D = 4'h0;
            @(posedge clk);
            #1;
            $display("Test %0d: Priority B over A", test_num);
            #1;

            check_outputs(1'b1, 4'h3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4;
            @(posedge clk);
            #1;
            $display("Test %0d: All active (D wins)", test_num);
            #1;

            check_outputs(1'b1, 4'h4);
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
        testcase009();
        
        
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
        input expected_EN;
        input [3:0] expected_Y;
        begin
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: EN=%b, Y=%h",
                         EN, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%b, Y=%h",
                         expected_EN, expected_Y);
                $display("  Got:      EN=%b, Y=%h",
                         EN, Y);
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
        $dumpvars(0,A, B, C, D, clk, EN, Y);
    end

endmodule
