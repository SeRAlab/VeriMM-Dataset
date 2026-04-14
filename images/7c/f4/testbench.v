`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
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
            A = 0;
            B = 0;
            RST = 1;
            @(posedge CLK);
            #1 RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Multiplication (3 * 4)", test_num);
            reset_dut();
            A = 4'd3;
            B = 4'd4;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Accumulation Step ( (2*3) + (4*5) )", test_num);
            reset_dut();

            A = 4'd2;
            B = 4'd3;
            @(posedge CLK);
            #1;

            A = 4'd4;
            B = 4'd5;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'd26);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by Zero", test_num);
            reset_dut();

            A = 4'd5;
            B = 4'd0;
            @(posedge CLK);
            #1;

            A = 4'd0;
            B = 4'd10;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum 4-bit Values (15 * 15)", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'd225);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 8-bit Overflow Handling", test_num);
            reset_dut();

            A = 4'd15;
            B = 4'd10;
            @(posedge CLK);
            #1;


            A = 4'd15;
            B = 4'd10;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Operations and Mid-stream Reset", test_num);
            reset_dut();

            A = 4'd5;
            B = 4'd5;
            @(posedge CLK);
            #1;

            RST = 1;
            @(posedge CLK);
            #1 RST = 0;

            A = 4'd1;
            B = 4'd1;
            @(posedge CLK);
            #1 #1;
 check_outputs(8'd1);
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
        $dumpvars(0,A, B, CLK, RST, C);
    end

endmodule
