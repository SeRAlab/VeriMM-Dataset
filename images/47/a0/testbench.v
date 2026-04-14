`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLK;
    reg OP;
    reg RST;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .OP(OP),
        .RST(RST),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 0;
            B = 0;
            OP = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (15 + 25)", test_num);
            reset_dut();
            A = 8'd15;
            B = 8'd25;
            OP = 1'b0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction (50 - 20)", test_num);
            reset_dut();
            A = 8'd50;
            B = 8'd20;
            OP = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Overflow (250 + 10)", test_num);
            reset_dut();
            A = 8'd250;
            B = 8'd10;
            OP = 1'b0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Underflow (10 - 20)", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            OP = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Result Zero (128 - 128)", test_num);
            reset_dut();
            A = 8'd128;
            B = 8'd128;
            OP = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Addition (255 + 255)", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            OP = 1'b0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify reset forces output to zero", test_num);
            reset_dut();


            RST = 1;
            A = 8'd55;
            B = 8'd45;
            OP = 1'b0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'd0);
            RST = 0;
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
        input [7:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, CLK, OP, RST, C);
    end

endmodule
