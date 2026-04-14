`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] dataIn;
    reg [7:0] myReg4;
    reg [7:0] myReg5;
    reg [7:0] myReg6;
    reg [7:0] myReg7;
    reg writeEn;
    wire [7:0] dataOut;
    wire [7:0] myReg0;
    wire [7:0] myReg1;
    wire [7:0] myReg2;
    wire [7:0] myReg3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .dataIn(dataIn),
        .myReg4(myReg4),
        .myReg5(myReg5),
        .myReg6(myReg6),
        .myReg7(myReg7),
        .writeEn(writeEn),
        .dataOut(dataOut),
        .myReg0(myReg0),
        .myReg1(myReg1),
        .myReg2(myReg2),
        .myReg3(myReg3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            writeEn = 1;

            addr = 8'd0; dataIn = 8'h00; @(posedge clk);
            addr = 8'd1; dataIn = 8'h00; @(posedge clk);
            addr = 8'd2; dataIn = 8'h00; @(posedge clk);
            addr = 8'd3; dataIn = 8'h00; @(posedge clk);

            writeEn = 0;
            addr = 8'h00;
            dataIn = 8'h00;
            myReg4 = 8'h00;
            myReg5 = 8'h00;
            myReg6 = 8'h00;
            myReg7 = 8'h00;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Write and Read myReg0", test_num);
            addr = 8'h00;
            dataIn = 8'hAA;
            writeEn = 1;
            @(posedge clk);
            writeEn = 0;
            addr = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 8'hAA, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Write and Read myReg1", test_num);
            addr = 8'h01;
            dataIn = 8'h55;
            writeEn = 1;
            @(posedge clk);
            writeEn = 0;
            addr = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 8'h00, 8'h55, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Write and Read myReg2", test_num);
            addr = 8'h02;
            dataIn = 8'h12;
            writeEn = 1;
            @(posedge clk);
            writeEn = 0;
            addr = 8'h02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h12, 8'h00, 8'h00, 8'h12, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Write and Read myReg3", test_num);
            addr = 8'h03;
            dataIn = 8'hF0;
            writeEn = 1;
            @(posedge clk);
            writeEn = 0;
            addr = 8'h03;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0, 8'h00, 8'h00, 8'h00, 8'hF0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Read from external input myReg4", test_num);
            myReg4 = 8'hDE;
            addr = 8'h04;
            writeEn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hDE, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Read from external input myReg5", test_num);
            myReg5 = 8'hAD;
            addr = 8'h05;
            writeEn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAD, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Read from external input myReg6", test_num);
            myReg6 = 8'hBE;
            addr = 8'h06;
            writeEn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBE, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Read from external input myReg7", test_num);
            myReg7 = 8'hEF;
            addr = 8'h07;
            writeEn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hEF, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test %0d: Verify writeEn low prevents writing", test_num);
            addr = 8'h00;
            dataIn = 8'hFF;
            writeEn = 0;
            @(posedge clk);
            addr = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Test %0d: Multiple register persistence", test_num);
            writeEn = 1;
            addr = 8'h00; dataIn = 8'h01; @(posedge clk);
            addr = 8'h01; dataIn = 8'h02; @(posedge clk);
            addr = 8'h02; dataIn = 8'h03; @(posedge clk);
            addr = 8'h03; dataIn = 8'h04; @(posedge clk);
            writeEn = 0;
            addr = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02, 8'h01, 8'h02, 8'h03, 8'h04);
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
        input [7:0] expected_dataOut;
        input [7:0] expected_myReg0;
        input [7:0] expected_myReg1;
        input [7:0] expected_myReg2;
        input [7:0] expected_myReg3;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut) &&
                expected_myReg0 === (expected_myReg0 ^ myReg0 ^ expected_myReg0) &&
                expected_myReg1 === (expected_myReg1 ^ myReg1 ^ expected_myReg1) &&
                expected_myReg2 === (expected_myReg2 ^ myReg2 ^ expected_myReg2) &&
                expected_myReg3 === (expected_myReg3 ^ myReg3 ^ expected_myReg3)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h, myReg0=%h, myReg1=%h, myReg2=%h, myReg3=%h",
                         dataOut, myReg0, myReg1, myReg2, myReg3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h, myReg0=%h, myReg1=%h, myReg2=%h, myReg3=%h",
                         expected_dataOut, expected_myReg0, expected_myReg1, expected_myReg2, expected_myReg3);
                $display("  Got:      dataOut=%h, myReg0=%h, myReg1=%h, myReg2=%h, myReg3=%h",
                         dataOut, myReg0, myReg1, myReg2, myReg3);
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
        $dumpvars(0,addr, clk, dataIn, myReg4, myReg5, myReg6, myReg7, writeEn, dataOut, myReg0, myReg1, myReg2, myReg3);
    end

endmodule
