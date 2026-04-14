`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [4:0] fn;
    reg rst;
    wire Cout;
    wire [7:0] Y;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .fn(fn),
        .rst(rst),
        .Cout(Cout),
        .Y(Y),
        .Zero(Zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 8'h0;
            B = 8'h0;
            fn = 5'h0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Addition (15 + 10)", test_num);
            reset_dut();
            A = 8'd15;
            B = 8'd10;
            fn = 5'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd25, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Addition with Carry (255 + 1)", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'h01;
            fn = 5'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Subtraction (50 - 20)", test_num);
            reset_dut();
            A = 8'd50;
            B = 8'd20;
            fn = 5'h01;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Bitwise AND", test_num);
            reset_dut();
            A = 8'b1010_1010;
            B = 8'b1111_0000;
            fn = 5'h02;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'b1010_0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Bitwise OR", test_num);
            reset_dut();
            A = 8'hAA;
            B = 8'h55;
            fn = 5'h03;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'hFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Bitwise XOR (Self)", test_num);
            reset_dut();
            A = 8'hF0;
            B = 8'hF0;
            fn = 5'h04;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Logical Shift Left (0x01 << 1)", test_num);
            reset_dut();
            A = 8'h01;
            B = 8'h01;
            fn = 5'h05;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h02, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Logical Shift Right (0x80 >> 1)", test_num);
            reset_dut();
            A = 8'h80;
            B = 8'h01;
            fn = 5'h06;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h40, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Rotate Left (0x80 ROL 1)", test_num);
            reset_dut();
            A = 8'h80;
            B = 8'h01;
            fn = 5'h07;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h01, 1'b0);
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
        input [7:0] expected_Y;
        input expected_Zero;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Y=%h, Zero=%b",
                         Cout, Y, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Y=%h, Zero=%b",
                         expected_Cout, expected_Y, expected_Zero);
                $display("  Got:      Cout=%b, Y=%h, Zero=%b",
                         Cout, Y, Zero);
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
        $dumpvars(0,A, B, clk, fn, rst, Cout, Y, Zero);
    end

endmodule
