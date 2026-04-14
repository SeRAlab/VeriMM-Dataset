`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] addr;
    reg rdEn;
    reg [7:0] wrData;
    reg wrEn;
    wire [7:0] Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .addr(addr),
        .rdEn(rdEn),
        .wrData(wrData),
        .wrEn(wrEn),
        .Data(Data)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            rdEn = 0;
            wrEn = 0;
            addr = 8'h00;
            wrData = 32'h0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 8'h00;
            rdEn = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(32'hAABBCCDD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 8'h01;
            rdEn = 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(32'h11223344);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 8'h02;
            rdEn = 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(32'h55667788);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 8'h00;
            rdEn = 0;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(32'hXXXXXXXX);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 8'hFF;
            rdEn = 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(32'hXXXXXXXX);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 8'h00;
            wrEn = 1;
            wrData = 32'hFFFFFFFF;
            rdEn = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(32'hAABBCCDD);
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
        input [7:0] expected_Data;
        begin
            if (expected_Data === (expected_Data ^ Data ^ expected_Data)) begin
                $display("PASS");
                $display("  Outputs: Data=%h",
                         Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data=%h",
                         expected_Data);
                $display("  Got:      Data=%h",
                         Data);
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
        $dumpvars(0,Clk, addr, rdEn, wrData, wrEn, Data);
    end

endmodule
