`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d3;
    reg ear;
    reg en254r;
    reg en254w;
    reg [4:0] kbd;
    wire [5:0] dout;
    wire mic;
    wire spk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d3(d3),
        .ear(ear),
        .en254r(en254r),
        .en254w(en254w),
        .kbd(kbd),
        .dout(dout),
        .mic(mic),
        .spk(spk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en254r = 0;
            en254w = 0;
            kbd = 5'b0;
            ear = 0;
            d3 = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            en254r = 1;
            kbd = 5'b11111;
            ear = 1;
            #10;

            #1;


            check_outputs(6'h3F, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            en254r = 1;
            kbd = 5'b01010;
            ear = 0;
            #10;

            #1;


            check_outputs(6'h0A, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            en254w = 1;
            d3 = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(6'h00, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            en254w = 1;
            d3 = 1;
            @(posedge clk);
            #2;

            d3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(6'h00, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            en254w = 1;
            d3 = 1;
            @(posedge clk);
            #2;

            en254w = 0;
            d3 = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(6'h00, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            en254r = 0;
            kbd = 5'b11111;
            ear = 1;
            #10;

            #1;


            check_outputs(6'h00, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            en254r = 1;
            en254w = 1;
            kbd = 5'b10110;
            ear = 1;
            d3 = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(6'h36, 1, 1);
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
        input [5:0] expected_dout;
        input expected_mic;
        input expected_spk;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_mic === (expected_mic ^ mic ^ expected_mic) &&
                expected_spk === (expected_spk ^ spk ^ expected_spk)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, mic=%b, spk=%b",
                         dout, mic, spk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, mic=%b, spk=%b",
                         expected_dout, expected_mic, expected_spk);
                $display("  Got:      dout=%h, mic=%b, spk=%b",
                         dout, mic, spk);
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
        $dumpvars(0,clk, d3, ear, en254r, en254w, kbd, dout, mic, spk);
    end

endmodule
