`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] AWGN;
    reg [15:0] BPSK;
    reg CLK;
    reg en;
    wire [16:0] BPSK_AWGN;
    wire en_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AWGN(AWGN),
        .BPSK(BPSK),
        .CLK(CLK),
        .en(en),
        .BPSK_AWGN(BPSK_AWGN),
        .en_status(en_status)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            en = 0;
            BPSK = 0;
            AWGN = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic addition (en=1)", test_num);
            reset_dut();

            en = 1;
            BPSK = 16'h1000;
            AWGN = 16'h2000;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(17'h3000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum sum (0xFFFF + 0xFFFF)", test_num);
            reset_dut();

            en = 1;
            BPSK = 16'hFFFF;
            AWGN = 16'hFFFF;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(17'h1FFFE, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Disabled operation (en=0)", test_num);
            reset_dut();

            en = 0;
            BPSK = 16'hABCD;
            AWGN = 16'h1234;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(17'h00000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mid-range carry check", test_num);
            reset_dut();

            en = 1;
            BPSK = 16'h8000;
            AWGN = 16'h8000;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(17'h10000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero inputs while enabled", test_num);
            reset_dut();

            en = 1;
            BPSK = 16'h0000;
            AWGN = 16'h0000;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(17'h00000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transition from disabled to enabled", test_num);
            reset_dut();


            en = 0;
            BPSK = 16'h1111;
            AWGN = 16'h2222;
            @(posedge CLK);


            en = 1;
            BPSK = 16'h1111;
            AWGN = 16'h2222;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(17'h03333, 1'b1);
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
        input [16:0] expected_BPSK_AWGN;
        input expected_en_status;
        begin
            if (expected_BPSK_AWGN === (expected_BPSK_AWGN ^ BPSK_AWGN ^ expected_BPSK_AWGN) &&
                expected_en_status === (expected_en_status ^ en_status ^ expected_en_status)) begin
                $display("PASS");
                $display("  Outputs: BPSK_AWGN=%h, en_status=%b",
                         BPSK_AWGN, en_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BPSK_AWGN=%h, en_status=%b",
                         expected_BPSK_AWGN, expected_en_status);
                $display("  Got:      BPSK_AWGN=%h, en_status=%b",
                         BPSK_AWGN, en_status);
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
        $dumpvars(0,AWGN, BPSK, CLK, en, BPSK_AWGN, en_status);
    end

endmodule
