`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Clk;
    reg Sel;
    wire Cout;
    wire [3:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Clk(Clk),
        .Sel(Sel),
        .Cout(Cout),
        .Result(Result)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            @(negedge Clk);
            A = 0;
            B = 0;
            Sel = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition without carry (5 + 3)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd5;
            B = 4'd3;
            Sel = 1'b0;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition with carry (10 + 10)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd10;
            B = 4'd10;
            Sel = 1'b0;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition boundary (15 + 1)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd15;
            B = 4'd1;
            Sel = 1'b0;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction without borrow (10 - 4)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd10;
            B = 4'd4;
            Sel = 1'b1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction with borrow (4 - 10)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd4;
            B = 4'd10;
            Sel = 1'b1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction boundary (0 - 1)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd0;
            B = 4'd1;
            Sel = 1'b1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction resulting in zero (15 - 15)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd15;
            B = 4'd15;
            Sel = 1'b1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition of zeros", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd0;
            B = 4'd0;
            Sel = 1'b0;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Max addition (15 + 15)", test_num);
            reset_dut();
            @(negedge Clk);
            A = 4'd15;
            B = 4'd15;
            Sel = 1'b0;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Toggle Mode (8 and 3)", test_num);


            reset_dut();
            @(negedge Clk);
            A = 4'd8; B = 4'd3; Sel = 1'b0;
            @(posedge Clk);
            #1;


            @(negedge Clk);
            Sel = 1'b1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd5);
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
        testcase010();
        
        
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
        input expected_Cout;
        input [3:0] expected_Result;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Result=%h",
                         Cout, Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Result=%h",
                         expected_Cout, expected_Result);
                $display("  Got:      Cout=%b, Result=%h",
                         Cout, Result);
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
        $dumpvars(0,A, B, Clk, Sel, Cout, Result);
    end

endmodule
