`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_RX;
    reg DATA_RX;
    reg MKD_RX;
    reg RST;
    wire [15:0] DATA;
    wire FRAME_START;
    wire WRITE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_RX(CLK_RX),
        .DATA_RX(DATA_RX),
        .MKD_RX(MKD_RX),
        .RST(RST),
        .DATA(DATA),
        .FRAME_START(FRAME_START),
        .WRITE(WRITE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_RX = 0;
        forever #5 CLK_RX = ~CLK_RX;
    end

        task reset_dut;

        begin
            RST = 1;
            DATA_RX = 0;
            MKD_RX = 0;
            repeat (2) @(posedge CLK_RX);
            #1 RST = 0;
            repeat (2) @(posedge CLK_RX);
        end
        endtask
    task send_data;

        input [15:0] value;
        integer i;
        begin
            for (i = 15; i >= 0; i = i - 1) begin
                DATA_RX = value[i];
                @(posedge CLK_RX);
                #1;
            end
        end
        endtask

    task trigger_marker;

        begin
            MKD_RX = 1;
            @(posedge CLK_RX);
            #1 MKD_RX = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Reception (0xABCD)", test_num);
            reset_dut();

            trigger_marker();
            send_data(16'hABCD);




            #1;





            check_outputs(16'hABCD, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (0xFFFF)", test_num);
            reset_dut();

            trigger_marker();
            send_data(16'hFFFF);

            #1;


            check_outputs(16'hFFFF, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (0x0000)", test_num);
            reset_dut();

            trigger_marker();
            send_data(16'h0000);

            #1;


            check_outputs(16'h0000, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (0x5555)", test_num);
            reset_dut();

            trigger_marker();
            send_data(16'h5555);

            #1;


            check_outputs(16'h5555, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Consecutive Frames", test_num);
            reset_dut();


            trigger_marker();
            send_data(16'h1234);


            trigger_marker();
            send_data(16'h8765);

            #1;


            check_outputs(16'h8765, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset during Frame", test_num);
            reset_dut();

            trigger_marker();
            send_data(16'hAAAA);


            RST = 1;
            #20 RST = 0;
            repeat (2) @(posedge CLK_RX);


            #1;



            check_outputs(16'h0000, 1'b0, 1'b0);
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
        input [15:0] expected_DATA;
        input expected_FRAME_START;
        input expected_WRITE;
        begin
            if (expected_DATA === (expected_DATA ^ DATA ^ expected_DATA) &&
                expected_FRAME_START === (expected_FRAME_START ^ FRAME_START ^ expected_FRAME_START) &&
                expected_WRITE === (expected_WRITE ^ WRITE ^ expected_WRITE)) begin
                $display("PASS");
                $display("  Outputs: DATA=%h, FRAME_START=%b, WRITE=%b",
                         DATA, FRAME_START, WRITE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA=%h, FRAME_START=%b, WRITE=%b",
                         expected_DATA, expected_FRAME_START, expected_WRITE);
                $display("  Got:      DATA=%h, FRAME_START=%b, WRITE=%b",
                         DATA, FRAME_START, WRITE);
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
        $dumpvars(0,CLK_RX, DATA_RX, MKD_RX, RST, DATA, FRAME_START, WRITE);
    end

endmodule
