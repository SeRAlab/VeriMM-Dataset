`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SaltoCond;
    reg Saltoincond;
    reg clk;
    reg [31:0] extSigno;
    reg [31:0] instru;
    reg oZero;
    reg reset;
    wire [31:0] direinstru;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SaltoCond(SaltoCond),
        .Saltoincond(Saltoincond),
        .clk(clk),
        .extSigno(extSigno),
        .instru(instru),
        .oZero(oZero),
        .reset(reset),
        .direinstru(direinstru)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            SaltoCond = 0;
            Saltoincond = 0;
            extSigno = 0;
            oZero = 0;
            instru = 0;
            @(posedge clk);
            #2;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            SaltoCond = 0;
            Saltoincond = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            SaltoCond = 0;
            Saltoincond = 0;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_000C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            SaltoCond = 0;
            @(posedge clk);
            #2;




            SaltoCond = 1;
            oZero = 1;
            extSigno = 32'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();



            Saltoincond = 1;
            extSigno = 32'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_0018);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge clk);
            #2;


            SaltoCond = 1;
            oZero = 0;
            extSigno = 32'hFFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_0008);
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
        input [31:0] expected_direinstru;
        begin
            if (expected_direinstru === (expected_direinstru ^ direinstru ^ expected_direinstru)) begin
                $display("PASS");
                $display("  Outputs: direinstru=%h",
                         direinstru);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direinstru=%h",
                         expected_direinstru);
                $display("  Got:      direinstru=%h",
                         direinstru);
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
        $dumpvars(0,SaltoCond, Saltoincond, clk, extSigno, instru, oZero, reset, direinstru);
    end

endmodule
