`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ABCD;
    reg clk;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABCD(ABCD),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ABCD = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ABCD = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ABCD = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ABCD = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ABCD = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFF7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ABCD = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ABCD = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFDF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ABCD = 4'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFBF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            ABCD = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFF7F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            ABCD = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFEFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            ABCD = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFDFF);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_dut();
            ABCD = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFBFF);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            reset_dut();
            ABCD = 4'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF7FF);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            reset_dut();
            ABCD = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hEFFF);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            reset_dut();
            ABCD = 4'd13;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hDFFF);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            reset_dut();
            ABCD = 4'd14;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hBFFF);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            reset_dut();
            ABCD = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7FFF);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,ABCD, clk, out);
    end

endmodule
