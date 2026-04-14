`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [23:0] D0;
    reg [23:0] D1;
    reg [23:0] D2;
    reg [23:0] D3;
    reg [23:0] D4;
    reg [23:0] D5;
    reg [23:0] D6;
    reg [23:0] D7;
    reg Reset;
    reg [2:0] pattern;
    wire [23:0] ImgProcess;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5),
        .D6(D6),
        .D7(D7),
        .Reset(Reset),
        .pattern(pattern),
        .ImgProcess(ImgProcess)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            D0 = 24'h0; D1 = 24'h0; D2 = 24'h0; D3 = 24'h0;
            D4 = 24'h0; D5 = 24'h0; D6 = 24'h0; D7 = 24'h0;
            pattern = 3'b000;
            @(posedge Clock);
            #1 Reset = 0;
            @(posedge Clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select D0", test_num);
            reset_dut();
            D0 = 24'hAA55FF;
            pattern = 3'b000;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'hAA55FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select D1", test_num);
            reset_dut();
            D1 = 24'h112233;
            pattern = 3'b001;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'h112233);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select D2", test_num);
            reset_dut();
            D2 = 24'h445566;
            pattern = 3'b010;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'h445566);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select D3", test_num);
            reset_dut();
            D3 = 24'h778899;
            pattern = 3'b011;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'h778899);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select D4", test_num);
            reset_dut();
            D4 = 24'hABCDEF;
            pattern = 3'b100;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'hABCDEF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select D5", test_num);
            reset_dut();
            D5 = 24'hFEDCBA;
            pattern = 3'b101;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'hFEDCBA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select D6", test_num);
            reset_dut();
            D6 = 24'h00FFFF;
            pattern = 3'b110;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'h00FFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Select D7", test_num);
            reset_dut();
            D7 = 24'hFF00FF;
            pattern = 3'b111;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'hFF00FF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Dynamic Switching", test_num);
            reset_dut();
            D2 = 24'h123456;
            D5 = 24'h654321;


            pattern = 3'b010;
            @(posedge Clock);
            #1;


            pattern = 3'b101;
            @(posedge Clock);
            #1 #1;
 check_outputs(24'h654321);
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
        input [23:0] expected_ImgProcess;
        begin
            if (expected_ImgProcess === (expected_ImgProcess ^ ImgProcess ^ expected_ImgProcess)) begin
                $display("PASS");
                $display("  Outputs: ImgProcess=%h",
                         ImgProcess);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ImgProcess=%h",
                         expected_ImgProcess);
                $display("  Got:      ImgProcess=%h",
                         ImgProcess);
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
        $dumpvars(0,Clock, D0, D1, D2, D3, D4, D5, D6, D7, Reset, pattern, ImgProcess);
    end

endmodule
