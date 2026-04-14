`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clock;
    reg [6:0] i_segments_digit_0;
    reg [6:0] i_segments_digit_1;
    wire o_sev_seg_cathode;
    wire [6:0] o_sev_segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clock(i_clock),
        .i_segments_digit_0(i_segments_digit_0),
        .i_segments_digit_1(i_segments_digit_1),
        .o_sev_seg_cathode(o_sev_seg_cathode),
        .o_sev_segments(o_sev_segments)
    );

    // Clock generation (10ns period)
    initial begin
        i_clock = 0;
        forever #5 i_clock = ~i_clock;
    end

        task reset_dut;

        begin
            i_segments_digit_0 = 7'b0;
            i_segments_digit_1 = 7'b0;


            @(posedge i_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Display Digit 0", test_num);
            reset_dut();
            i_segments_digit_0 = 7'b1010101;
            i_segments_digit_1 = 7'b0101010;



            if (o_sev_seg_cathode !== 1'b0) begin
                @(posedge i_clock);
                #1;
            end

            #1;


            check_outputs(1'b0, 7'b1010101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Display Digit 1", test_num);
            reset_dut();
            i_segments_digit_0 = 7'h7F;
            i_segments_digit_1 = 7'h01;


            if (o_sev_seg_cathode !== 1'b0) begin
                @(posedge i_clock);
                #1;
            end


            @(posedge i_clock);
            #1;

            #1;


            check_outputs(1'b1, 7'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Full Toggle Cycle", test_num);
            reset_dut();
            i_segments_digit_0 = 7'h12;
            i_segments_digit_1 = 7'h34;


            if (o_sev_seg_cathode !== 1'b0) begin
                @(posedge i_clock);
                #1;
            end


            @(posedge i_clock);
            #1;

            @(posedge i_clock);
            #1;

            #1;


            check_outputs(1'b0, 7'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data update on Digit 1", test_num);
            reset_dut();
            i_segments_digit_0 = 7'h00;
            i_segments_digit_1 = 7'hAA;


            if (o_sev_seg_cathode !== 1'b1) begin
                @(posedge i_clock);
                #1;
            end


            i_segments_digit_1 = 7'h55;
            #1;

            #1;


            check_outputs(1'b1, 7'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Rapid Toggle Stability", test_num);
            reset_dut();
            i_segments_digit_0 = 7'h0F;
            i_segments_digit_1 = 7'hF0;

            repeat(5) @(posedge i_clock);
            #1;





            if (o_sev_seg_cathode == 1'b1)
                #1;

                check_outputs(1'b1, 7'hF0);
            else
                #1;

                check_outputs(1'b0, 7'h0F);
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
        input expected_o_sev_seg_cathode;
        input [6:0] expected_o_sev_segments;
        begin
            if (expected_o_sev_seg_cathode === (expected_o_sev_seg_cathode ^ o_sev_seg_cathode ^ expected_o_sev_seg_cathode) &&
                expected_o_sev_segments === (expected_o_sev_segments ^ o_sev_segments ^ expected_o_sev_segments)) begin
                $display("PASS");
                $display("  Outputs: o_sev_seg_cathode=%b, o_sev_segments=%h",
                         o_sev_seg_cathode, o_sev_segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_sev_seg_cathode=%b, o_sev_segments=%h",
                         expected_o_sev_seg_cathode, expected_o_sev_segments);
                $display("  Got:      o_sev_seg_cathode=%b, o_sev_segments=%h",
                         o_sev_seg_cathode, o_sev_segments);
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
        $dumpvars(0,i_clock, i_segments_digit_0, i_segments_digit_1, o_sev_seg_cathode, o_sev_segments);
    end

endmodule
