`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addrA;
    reg [11:0] addrB;
    reg [11:0] addrW;
    reg clk;
    reg [8:0] dataIn;
    reg enable;
    wire [8:0] dataOutA;
    wire [8:0] dataOutB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addrA(addrA),
        .addrB(addrB),
        .addrW(addrW),
        .clk(clk),
        .dataIn(dataIn),
        .enable(enable),
        .dataOutA(dataOutA),
        .dataOutB(dataOutB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            addrA = 0;
            addrB = 0;
            addrW = 0;
            dataIn = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write then Read back...");
            reset_dut();


            enable = 1;
            addrW = 12'h010;
            dataIn = 9'h123;
            @(posedge clk);
            #1;


            addrA = 12'h010;
            addrB = 12'h010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h123, 9'h123);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write to two addresses, then read simultaneously...");
            reset_dut();
            enable = 1;


            addrW = 12'h100;
            dataIn = 9'h0AA;
            @(posedge clk);
            #1;


            addrW = 12'h200;
            dataIn = 9'h0BB;
            @(posedge clk);
            #1;


            addrA = 12'h100;
            addrB = 12'h200;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h0AA, 9'h0BB);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify enable=0 prevents writes and output updates...");
            reset_dut();


            enable = 1;
            addrW = 12'hABC;
            dataIn = 9'h155;
            @(posedge clk);
            #1;


            addrA = 12'hABC;
            addrB = 12'hABC;
            @(posedge clk);
            #1;


            enable = 0;
            addrW = 12'hABC;
            dataIn = 9'h000;
            addrA = 12'h001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h155, 9'h155);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Simultaneous read and write operations...");
            reset_dut();
            enable = 1;


            addrW = 12'h300;
            dataIn = 9'h1FF;
            @(posedge clk);
            #1;


            addrA = 12'h300;
            addrB = 12'h300;
            addrW = 12'h400;
            dataIn = 9'h077;
            @(posedge clk);
            #1;


            addrA = 12'h400;
            addrB = 12'h400;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h077, 9'h077);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary address (0xFFF)...");
            reset_dut();
            enable = 1;

            addrW = 12'hFFF;
            dataIn = 9'h101;
            @(posedge clk);
            #1;

            addrA = 12'hFFF;
            addrB = 12'h000;
            @(posedge clk);
            #1;




            addrA = 12'hFFF;
            addrB = 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h101, 9'h101);
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
        input [8:0] expected_dataOutA;
        input [8:0] expected_dataOutB;
        begin
            if (expected_dataOutA === (expected_dataOutA ^ dataOutA ^ expected_dataOutA) &&
                expected_dataOutB === (expected_dataOutB ^ dataOutB ^ expected_dataOutB)) begin
                $display("PASS");
                $display("  Outputs: dataOutA=%h, dataOutB=%h",
                         dataOutA, dataOutB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOutA=%h, dataOutB=%h",
                         expected_dataOutA, expected_dataOutB);
                $display("  Got:      dataOutA=%h, dataOutB=%h",
                         dataOutA, dataOutB);
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
        $dumpvars(0,addrA, addrB, addrW, clk, dataIn, enable, dataOutA, dataOutB);
    end

endmodule
