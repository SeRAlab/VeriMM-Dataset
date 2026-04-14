`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg clk;
    wire [7:0] max;

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
        .max(max)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            C = 0;
            D = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A is max", test_num);
            reset_dut();
            A = 8'd255; B = 8'd10; C = 8'd50; D = 8'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: B is max", test_num);
            reset_dut();
            A = 8'd10; B = 8'd150; C = 8'd50; D = 8'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C is max", test_num);
            reset_dut();
            A = 8'd10; B = 8'd50; C = 8'd200; D = 8'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: D is max", test_num);
            reset_dut();
            A = 8'd10; B = 8'd50; C = 8'd100; D = 8'd250;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd250);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs equal", test_num);
            reset_dut();
            A = 8'hAA; B = 8'hAA; C = 8'hAA; D = 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            reset_dut();
            A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two inputs equal and max", test_num);
            reset_dut();
            A = 8'd128; B = 8'd128; C = 8'd10; D = 8'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decreasing sequence", test_num);
            reset_dut();
            A = 8'd100; B = 8'd90; C = 8'd80; D = 8'd70;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increasing sequence", test_num);
            reset_dut();
            A = 8'd10; B = 8'd20; C = 8'd30; D = 8'd40;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd40);
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
        input [7:0] expected_max;
        begin
            if (expected_max === (expected_max ^ max ^ expected_max)) begin
                $display("PASS");
                $display("  Outputs: max=%h",
                         max);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h",
                         expected_max);
                $display("  Got:      max=%h",
                         max);
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
        $dumpvars(0,A, B, C, D, clk, max);
    end

endmodule
