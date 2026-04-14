`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] datain;
    reg [3:0] readadr1;
    reg [3:0] readadr2;
    reg we;
    reg [3:0] writeadr;
    wire [7:0] dataout1;
    wire [7:0] dataout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .readadr1(readadr1),
        .readadr2(readadr2),
        .we(we),
        .writeadr(writeadr),
        .dataout1(dataout1),
        .dataout2(dataout2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            datain = 8'h00;
            readadr1 = 4'h0;
            readadr2 = 4'h0;
            writeadr = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            we = 1;
            writeadr = 4'd0;
            datain = 8'hFF;
            @(posedge clk);
            #1;


            we = 0;
            readadr1 = 4'd0;
            readadr2 = 4'd0;
            #1;

            $display("Testcase %0d: Register 0 Hardwired Zero", test_num);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            we = 1;
            writeadr = 4'd1;
            datain = 8'h5A;
            @(posedge clk);
            #1;


            we = 0;
            readadr1 = 4'd1;
            readadr2 = 4'd0;
            #1;

            $display("Testcase %0d: Simple Write/Read Register 1", test_num);
            #1;

            check_outputs(8'h5A, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            we = 1;
            writeadr = 4'd2;
            datain = 8'h11;
            @(posedge clk);
            #1;


            writeadr = 4'd3;
            datain = 8'h22;
            @(posedge clk);
            #1;


            we = 0;
            readadr1 = 4'd2;
            readadr2 = 4'd3;
            #1;

            $display("Testcase %0d: Simultaneous Dual Port Read", test_num);
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            we = 0;
            writeadr = 4'd5;
            datain = 8'hEE;
            @(posedge clk);
            #1;


            readadr1 = 4'd5;
            #1;

            $display("Testcase %0d: Write Enable (we) Check", test_num);

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            we = 1;
            writeadr = 4'd15;
            datain = 8'hBC;
            @(posedge clk);
            #1;


            we = 0;
            readadr2 = 4'd15;
            readadr1 = 4'd0;
            #1;

            $display("Testcase %0d: Max Address (Reg 15) Check", test_num);
            #1;

            check_outputs(8'h00, 8'hBC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            we = 1;
            writeadr = 4'd8;
            datain = 8'hAA;
            @(posedge clk);
            #1;


            datain = 8'hBB;
            @(posedge clk);
            #1;


            we = 0;
            readadr1 = 4'd8;
            readadr2 = 4'd8;
            #1;

            $display("Testcase %0d: Overwrite Register Check", test_num);
            #1;

            check_outputs(8'hBB, 8'hBB);
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
        input [7:0] expected_dataout1;
        input [7:0] expected_dataout2;
        begin
            if (expected_dataout1 === (expected_dataout1 ^ dataout1 ^ expected_dataout1) &&
                expected_dataout2 === (expected_dataout2 ^ dataout2 ^ expected_dataout2)) begin
                $display("PASS");
                $display("  Outputs: dataout1=%h, dataout2=%h",
                         dataout1, dataout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout1=%h, dataout2=%h",
                         expected_dataout1, expected_dataout2);
                $display("  Got:      dataout1=%h, dataout2=%h",
                         dataout1, dataout2);
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
        $dumpvars(0,clk, datain, readadr1, readadr2, we, writeadr, dataout1, dataout2);
    end

endmodule
