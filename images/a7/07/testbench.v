`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] din;
    reg [1:0] raa;
    reg [1:0] rab;
    reg rea;
    reg reb;
    reg [1:0] wa;
    reg we;
    wire [2:0] douta;
    wire [2:0] doutb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .raa(raa),
        .rab(rab),
        .rea(rea),
        .reb(reb),
        .wa(wa),
        .we(we),
        .douta(douta),
        .doutb(doutb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            we  = 0;
            wa  = 0;
            din = 0;
            rea = 0;
            reb = 0;
            raa = 0;
            rab = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(negedge clk);
            we = 1; wa = 2'd0; din = 3'd5;
            @(negedge clk);
            we = 0;

            rea = 1; raa = 2'd0;
            reb = 0;
            #2;
            $display("Testcase 001: Basic Write/Read Port A");
            #1;

            check_outputs(3'd5, 3'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(negedge clk);
            we = 1; wa = 2'd1; din = 3'd3;
            @(negedge clk);

            we = 1; wa = 2'd2; din = 3'd6;
            @(negedge clk);
            we = 0;

            rea = 1; raa = 2'd1;
            reb = 1; rab = 2'd2;
            #2;
            $display("Testcase 002: Dual Port Read");
            #1;

            check_outputs(3'd3, 3'd6);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(negedge clk);
            we = 1; wa = 2'd3; din = 3'd7;
            @(negedge clk);
            we = 0;

            rea = 1; raa = 2'd3;
            reb = 0; rab = 2'd3;
            #2;
            $display("Testcase 003: Read Enable Logic Check");
            #1;

            check_outputs(3'd7, 3'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge clk);
            we = 1; wa = 2'd0; din = 3'd2;
            @(negedge clk);

            we = 0; wa = 2'd0; din = 3'd7;
            @(negedge clk);

            rea = 1; raa = 2'd0;
            reb = 0;
            #2;
            $display("Testcase 004: Write Enable Logic Check");
            #1;

            check_outputs(3'd2, 3'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(negedge clk);
            we = 1; wa = 2'd2; din = 3'd1;
            @(negedge clk);

            we = 1; wa = 2'd2; din = 3'd4;
            @(negedge clk);
            we = 0;

            rea = 1; raa = 2'd2;
            reb = 1; rab = 2'd2;
            #2;
            $display("Testcase 005: Overwrite check");
            #1;

            check_outputs(3'd4, 3'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            @(negedge clk);
            we = 1; wa = 2'd1; din = 3'd5;
            @(negedge clk);
            we = 0;

            rea = 1; raa = 2'd1;
            reb = 1; rab = 2'd1;
            #2;
            $display("Testcase 006: Simultaneous Dual Read same Addr");
            #1;

            check_outputs(3'd5, 3'd5);
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
        input [2:0] expected_douta;
        input [2:0] expected_doutb;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta) &&
                expected_doutb === (expected_doutb ^ doutb ^ expected_doutb)) begin
                $display("PASS");
                $display("  Outputs: douta=%h, doutb=%h",
                         douta, doutb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h, doutb=%h",
                         expected_douta, expected_doutb);
                $display("  Got:      douta=%h, doutb=%h",
                         douta, doutb);
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
        $dumpvars(0,clk, din, raa, rab, rea, reb, wa, we, douta, doutb);
    end

endmodule
