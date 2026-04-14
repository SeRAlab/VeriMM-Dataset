`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] AR;
    reg [3:0] AW;
    reg [7:0] D;
    reg WE;
    reg clk;
    wire [7:0] QR;
    wire [7:0] QW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .AW(AW),
        .D(D),
        .WE(WE),
        .clk(clk),
        .QR(QR),
        .QW(QW)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            AR = 0;
            AW = 0;
            D = 0;
            WE = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            AW = 4'h5;
            AR = 4'h5;
            D = 8'hA5;
            WE = 1;

            @(negedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            AW = 4'h2;
            D = 8'hBB;
            WE = 1;
            @(negedge clk);


            AW = 4'hA;
            D = 8'hCC;
            WE = 1;
            @(negedge clk);


            AW = 4'h2;
            AR = 4'hA;
            #1;
            #1;

            check_outputs(8'hCC, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            AW = 4'h3;
            D = 8'h77;
            WE = 1;
            @(negedge clk);


            AW = 4'h3;
            D = 8'hEE;
            WE = 0;
            @(negedge clk);


            AR = 4'h3;
            AW = 4'h3;
            #1;
            #1;

            check_outputs(8'h77, 8'h77);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            AW = 4'h0;
            D = 8'h01;
            WE = 1;
            @(negedge clk);


            AW = 4'hF;
            D = 8'hFF;
            WE = 1;
            @(negedge clk);


            AW = 4'h0;
            AR = 4'hF;
            #1;
            #1;

            check_outputs(8'hFF, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            AW = 4'h8;
            D = 8'h11;
            WE = 1;
            @(negedge clk);


            AW = 4'h9;
            AR = 4'h8;
            D = 8'h22;
            WE = 1;
            @(negedge clk);


            #1;
            #1;

            check_outputs(8'h11, 8'h22);
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
        input [7:0] expected_QR;
        input [7:0] expected_QW;
        begin
            if (expected_QR === (expected_QR ^ QR ^ expected_QR) &&
                expected_QW === (expected_QW ^ QW ^ expected_QW)) begin
                $display("PASS");
                $display("  Outputs: QR=%h, QW=%h",
                         QR, QW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QR=%h, QW=%h",
                         expected_QR, expected_QW);
                $display("  Got:      QR=%h, QW=%h",
                         QR, QW);
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
        $dumpvars(0,AR, AW, D, WE, clk, QR, QW);
    end

endmodule
