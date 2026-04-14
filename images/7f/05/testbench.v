`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bcd;
    reg clock;
    wire [6:0] SeteSegmentos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .clock(clock),
        .SeteSegmentos(SeteSegmentos)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            bcd = 4'b0000;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd0;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 0", test_num);
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd1;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 1", test_num);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd2;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 2", test_num);
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd3;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 3", test_num);
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd4;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 4", test_num);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd5;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 5", test_num);
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd6;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 6", test_num);
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd7;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 7", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd8;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 8", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd9;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 9", test_num);
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd10;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 10 (Special)", test_num);
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd11;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 11 (Special)", test_num);
            #1;

            check_outputs(7'h7C);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            reset_dut();
            bcd = 4'd12;
            @(posedge clock);
            #2;
            $display("Test %0d: BCD = 12 (Special)", test_num);
            #1;

            check_outputs(7'h39);
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
        input [6:0] expected_SeteSegmentos;
        begin
            if (expected_SeteSegmentos === (expected_SeteSegmentos ^ SeteSegmentos ^ expected_SeteSegmentos)) begin
                $display("PASS");
                $display("  Outputs: SeteSegmentos=%h",
                         SeteSegmentos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SeteSegmentos=%h",
                         expected_SeteSegmentos);
                $display("  Got:      SeteSegmentos=%h",
                         SeteSegmentos);
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
        $dumpvars(0,bcd, clock, SeteSegmentos);
    end

endmodule
