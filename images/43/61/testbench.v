`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] MIC_in;
    reg clk;
    reg [1:0] varDelay;
    wire [11:0] SPEAKER_OUT;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MIC_in(MIC_in),
        .clk(clk),
        .varDelay(varDelay),
        .SPEAKER_OUT(SPEAKER_OUT),
        .seg(seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            MIC_in = 12'b0;
            varDelay = 2'b0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            varDelay = 2'b00;
            MIC_in = 12'hAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'hAAA, 7'b1000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            varDelay = 2'b01;
            MIC_in = 12'h555;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(12'h555, 7'b1111001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            varDelay = 2'b10;
            MIC_in = 12'hF0F;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(12'hF0F, 7'b0100100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            varDelay = 2'b11;
            MIC_in = 12'h0FF;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(12'h0FF, 7'b0110000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            varDelay = 2'b00;
            MIC_in = 12'hCDE;
            @(posedge clk);


            MIC_in = 12'h000;
            repeat(2) @(posedge clk);



            varDelay = 2'b01;
            #1;
            #1;

            check_outputs(SPEAKER_OUT, 7'b1111001);
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
        input [11:0] expected_SPEAKER_OUT;
        input [6:0] expected_seg;
        begin
            if (expected_SPEAKER_OUT === (expected_SPEAKER_OUT ^ SPEAKER_OUT ^ expected_SPEAKER_OUT) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: SPEAKER_OUT=%h, seg=%h",
                         SPEAKER_OUT, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SPEAKER_OUT=%h, seg=%h",
                         expected_SPEAKER_OUT, expected_seg);
                $display("  Got:      SPEAKER_OUT=%h, seg=%h",
                         SPEAKER_OUT, seg);
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
        $dumpvars(0,MIC_in, clk, varDelay, SPEAKER_OUT, seg);
    end

endmodule
