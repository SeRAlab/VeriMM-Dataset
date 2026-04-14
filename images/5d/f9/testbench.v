`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] D;
    reg Init;
    reg clk;
    reg creaenhe;
    reg rst;
    reg [2:0] scrinit;
    wire MsbOD;
    wire [6:0] Out_display;
    wire RS;
    wire RW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .Init(Init),
        .clk(clk),
        .creaenhe(creaenhe),
        .rst(rst),
        .scrinit(scrinit),
        .MsbOD(MsbOD),
        .Out_display(Out_display),
        .RS(RS),
        .RW(RW)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            D = 7'b0;
            Init = 0;
            creaenhe = 0;
            scrinit = 3'b000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 7'b0000000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: scrinit mode 001", test_num);
            reset_dut();
            scrinit = 3'b001;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 7'h38, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: scrinit mode 010", test_num);
            reset_dut();
            scrinit = 3'b010;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 7'h3F, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: scrinit mode 011", test_num);
            reset_dut();
            scrinit = 3'b011;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 7'h06, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: scrinit mode 100", test_num);
            reset_dut();
            scrinit = 3'b100;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 7'h5B, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: scrinit mode 101", test_num);
            reset_dut();
            scrinit = 3'b101;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 7'h4F, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: scrinit mode 110", test_num);
            reset_dut();
            scrinit = 3'b110;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 7'h66, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: scrinit mode 111", test_num);
            reset_dut();
            scrinit = 3'b111;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 7'h6D, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default mode, creaenhe=1", test_num);
            reset_dut();
            scrinit = 3'b000;
            creaenhe = 1;
            Init = 0;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 7'h01, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default mode, Init=1", test_num);
            reset_dut();
            scrinit = 3'b000;
            creaenhe = 0;
            Init = 1;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 7'h0C, 1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default mode, Data Pass-through", test_num);
            reset_dut();
            scrinit = 3'b000;
            creaenhe = 0;
            Init = 0;
            D = 7'h41;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 7'h41, 1'b1, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default mode, Data Pass-through (alt)", test_num);
            reset_dut();
            scrinit = 3'b000;
            creaenhe = 0;
            Init = 0;
            D = 7'h7F;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 7'h7F, 1'b1, 1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input expected_MsbOD;
        input [6:0] expected_Out_display;
        input expected_RS;
        input expected_RW;
        begin
            if (expected_MsbOD === (expected_MsbOD ^ MsbOD ^ expected_MsbOD) &&
                expected_Out_display === (expected_Out_display ^ Out_display ^ expected_Out_display) &&
                expected_RS === (expected_RS ^ RS ^ expected_RS) &&
                expected_RW === (expected_RW ^ RW ^ expected_RW)) begin
                $display("PASS");
                $display("  Outputs: MsbOD=%b, Out_display=%h, RS=%b, RW=%b",
                         MsbOD, Out_display, RS, RW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MsbOD=%b, Out_display=%h, RS=%b, RW=%b",
                         expected_MsbOD, expected_Out_display, expected_RS, expected_RW);
                $display("  Got:      MsbOD=%b, Out_display=%h, RS=%b, RW=%b",
                         MsbOD, Out_display, RS, RW);
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
        $dumpvars(0,D, Init, clk, creaenhe, rst, scrinit, MsbOD, Out_display, RS, RW);
    end

endmodule
