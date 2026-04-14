`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg M;
    reg RST;
    wire C;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .M(M),
        .RST(RST),
        .C(C),
        .S(S)
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
            M = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (5 + 3)", test_num);
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            M = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Carry (12 + 5)", test_num);
            reset_dut();
            A = 4'd12;
            B = 4'd5;
            M = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Max Values (15 + 15)", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            M = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Subtraction (10 - 4)", test_num);
            reset_dut();
            A = 4'd10;
            B = 4'd4;
            M = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction with Borrow (3 - 7)", test_num);
            reset_dut();
            A = 4'd3;
            B = 4'd7;
            M = 1;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(1'b1, 4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Equal Values (8 - 8)", test_num);
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            M = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (0 - 1)", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd1;
            M = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'hf);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset Action", test_num);

            reset_dut();
            A = 4'd10;
            B = 4'd2;
            M = 0;
            @(posedge CLK);
            #1;


            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
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
        input expected_C;
        input [3:0] expected_S;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
        $dumpvars(0,A, B, CLK, M, RST, C, S);
    end

endmodule
