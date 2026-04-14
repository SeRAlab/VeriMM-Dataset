`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_50;
    reg [7:0] xpositionG;
    reg [7:0] xpositionW;
    reg [6:0] ypositionG;
    reg [6:0] ypositionW;
    wire gameover;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_50(CLOCK_50),
        .xpositionG(xpositionG),
        .xpositionW(xpositionW),
        .ypositionG(ypositionG),
        .ypositionW(ypositionW),
        .gameover(gameover)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

        begin
            xpositionG <= 8'hA5;
            xpositionW <= 8'h5A;
            ypositionG <= 7'h3C;
            ypositionW <= 7'hC3;
            @(posedge CLOCK_50);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            xpositionG <= 8'd10;
            xpositionW <= 8'd20;
            ypositionG <= 7'd30;
            ypositionW <= 7'd30;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            xpositionG <= 8'd100;
            xpositionW <= 8'd100;
            ypositionG <= 7'd40;
            ypositionW <= 7'd45;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            xpositionG <= 8'd75;
            xpositionW <= 8'd75;
            ypositionG <= 7'd120;
            ypositionW <= 7'd120;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            xpositionG <= 8'd1;
            xpositionW <= 8'd255;
            ypositionG <= 7'd1;
            ypositionW <= 7'd127;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            xpositionG <= 8'd0;
            xpositionW <= 8'd0;
            ypositionG <= 7'd0;
            ypositionW <= 7'd0;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            xpositionG <= 8'hFF;
            xpositionW <= 8'hFF;
            ypositionG <= 7'h7F;
            ypositionW <= 7'h7F;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;

            xpositionG <= 8'd50; xpositionW <= 8'd50;
            ypositionG <= 7'd50; ypositionW <= 7'd50;
            @(posedge CLOCK_50);
            #1;

            xpositionG <= 8'd50; xpositionW <= 8'd51;
            ypositionG <= 7'd50; ypositionW <= 7'd50;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;

            xpositionG <= 8'd10; xpositionW <= 8'd10;
            ypositionG <= 7'd20; ypositionW <= 7'd21;
            @(posedge CLOCK_50);
            #1;

            xpositionG <= 8'd10; xpositionW <= 8'd10;
            ypositionG <= 7'd21; ypositionW <= 7'd21;
            @(posedge CLOCK_50);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_gameover;
        begin
            if (expected_gameover === (expected_gameover ^ gameover ^ expected_gameover)) begin
                $display("PASS");
                $display("  Outputs: gameover=%b",
                         gameover);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gameover=%b",
                         expected_gameover);
                $display("  Got:      gameover=%b",
                         gameover);
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
        $dumpvars(0,CLOCK_50, xpositionG, xpositionW, ypositionG, ypositionW, gameover);
    end

endmodule
