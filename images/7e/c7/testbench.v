`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] number;
    reg resetn;
    wire [7:0] anodes;
    wire dot;
    wire [6:0] seven_segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .number(number),
        .resetn(resetn),
        .anodes(anodes),
        .dot(dot),
        .seven_segments(seven_segments)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            resetn = 0;
            number = 0;
            repeat(10) @(posedge clock);
            resetn = 1;
            repeat(5) @(posedge clock);
        end
        endtask
    task testcase001;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros - Check Digit 0", test_num);
            reset_dut();
            number = 32'h00000000;


            timeout = 0;
            while (anodes !== 8'hFE && timeout < 5000) begin
                @(posedge clock);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(8'hFE, 1'b1, 7'h40);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0x12345678 - Check Digit 0 (Value 8)", test_num);
            reset_dut();
            number = 32'h12345678;

            timeout = 0;
            while (anodes !== 8'hFE && timeout < 5000) begin
                @(posedge clock);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(8'hFE, 1'b1, 7'h00);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0x12345678 - Check Digit 7 (Value 1)", test_num);
            reset_dut();
            number = 32'h12345678;

            timeout = 0;
            while (anodes !== 8'h7F && timeout < 5000) begin
                @(posedge clock);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(8'h7F, 1'b1, 7'h79);
        end
        endtask

    task testcase004;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0xABCDEF09 - Check Digit 4 (Value D)", test_num);
            reset_dut();
            number = 32'hABCDEF09;

            timeout = 0;
            while (anodes !== 8'hEF && timeout < 5000) begin
                @(posedge clock);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(8'hEF, 1'b1, 7'h21);
        end
        endtask

    task testcase005;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0xABCDEF09 - Check Digit 6 (Value B)", test_num);
            reset_dut();
            number = 32'hABCDEF09;

            timeout = 0;
            while (anodes !== 8'hBF && timeout < 5000) begin
                @(posedge clock);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(8'hBF, 1'b1, 7'h03);
        end
        endtask

    task testcase006;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0xABCDEF09 - Check Digit 2 (Value F)", test_num);
            reset_dut();
            number = 32'hABCDEF09;

            timeout = 0;
            while (anodes !== 8'hFB && timeout < 5000) begin
                @(posedge clock);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(8'hFB, 1'b1, 7'h0E);
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
        input [7:0] expected_anodes;
        input expected_dot;
        input [6:0] expected_seven_segments;
        begin
            if (expected_anodes === (expected_anodes ^ anodes ^ expected_anodes) &&
                expected_dot === (expected_dot ^ dot ^ expected_dot) &&
                expected_seven_segments === (expected_seven_segments ^ seven_segments ^ expected_seven_segments)) begin
                $display("PASS");
                $display("  Outputs: anodes=%h, dot=%b, seven_segments=%h",
                         anodes, dot, seven_segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anodes=%h, dot=%b, seven_segments=%h",
                         expected_anodes, expected_dot, expected_seven_segments);
                $display("  Got:      anodes=%h, dot=%b, seven_segments=%h",
                         anodes, dot, seven_segments);
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
        $dumpvars(0,clock, number, resetn, anodes, dot, seven_segments);
    end

endmodule
