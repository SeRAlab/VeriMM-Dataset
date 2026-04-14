`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D;
    reg clear;
    reg clock;
    reg enable;
    reg resetn;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clear(clear),
        .clock(clock),
        .enable(enable),
        .resetn(resetn),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            D = 32'h0;
            enable = 0;
            clear = 0;
            resetn = 0;
            #15;
            resetn = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Async Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Shift 4 Stages", test_num);
            reset_dut();
            enable = 1;


            D = 32'hDEAD_BEEF; @(posedge clock); #1;
            D = 32'h1234_5678; @(posedge clock); #1;
            D = 32'h8765_4321; @(posedge clock); #1;
            D = 32'hAAAA_5555; @(posedge clock); #1;


            #1;



            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Signal Logic", test_num);
            reset_dut();

            enable = 1;
            D = 32'hFFFF_FFFF; @(posedge clock); #1;

            enable = 0;
            D = 32'h0000_0000; @(posedge clock); #1;
            @(posedge clock); #1;

            enable = 1;
            D = 32'h1111_1111; @(posedge clock); #1;
            D = 32'h2222_2222; @(posedge clock); #1;
            D = 32'h3333_3333; @(posedge clock); #1;


            #1;



            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clear Signal Check", test_num);
            reset_dut();


            enable = 1;
            D = 32'hA0A0_A0A0; @(posedge clock); #1;
            D = 32'hB0B0_B0B0; @(posedge clock); #1;
            D = 32'hC0C0_C0C0; @(posedge clock); #1;
            D = 32'hD0D0_D0D0; @(posedge clock); #1;


            clear = 1;
            @(posedge clock); #1;
            clear = 0;


            #1;



            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous Shift Flow", test_num);
            reset_dut();
            enable = 1;


            D = 32'h1; @(posedge clock); #1;
            D = 32'h2; @(posedge clock); #1;
            D = 32'h3; @(posedge clock); #1;
            D = 32'h4; @(posedge clock); #1;


            D = 32'h5; @(posedge clock); #1;


            D = 32'h6; @(posedge clock); #1;

            #1;


            check_outputs(32'h0000_0003);
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clear, clock, enable, resetn, Q);
    end

endmodule
