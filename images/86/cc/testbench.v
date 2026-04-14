`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] CD;
    reg [7:0] VD;
    reg VDE;
    reg clk;
    wire [9:0] TMDS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CD(CD),
        .VD(VD),
        .VDE(VDE),
        .clk(clk),
        .TMDS(TMDS)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            VDE = 0;
            CD = 2'b00;
            VD = 8'h00;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            VDE = 0; CD = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(10'b1101010100);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            VDE = 0; CD = 2'b01;
            @(posedge clk); #1;
            #1;

            check_outputs(10'b0010101011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            VDE = 0; CD = 2'b10;
            @(posedge clk); #1;
            #1;

            check_outputs(10'b0101010101);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            VDE = 0; CD = 2'b11;
            @(posedge clk); #1;
            #1;

            check_outputs(10'b1010101010);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            VDE = 1; VD = 8'h00;
            @(posedge clk); #1;

            #1;


            check_outputs(10'h100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            VDE = 1; VD = 8'hFF;
            @(posedge clk); #1;

            #1;


            check_outputs(10'h200);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            VDE = 1; VD = 8'h55;
            @(posedge clk); #1;

            #1;


            check_outputs(10'h1CC);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            VDE = 1; VD = 8'h00;
            @(posedge clk);
            VD = 8'h00;
            @(posedge clk); #1;


            #1;



            check_outputs(10'h3FF);
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
        input [9:0] expected_TMDS;
        begin
            if (expected_TMDS === (expected_TMDS ^ TMDS ^ expected_TMDS)) begin
                $display("PASS");
                $display("  Outputs: TMDS=%h",
                         TMDS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TMDS=%h",
                         expected_TMDS);
                $display("  Got:      TMDS=%h",
                         TMDS);
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
        $dumpvars(0,CD, VD, VDE, clk, TMDS);
    end

endmodule
