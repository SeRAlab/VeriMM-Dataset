`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] A;
    reg [8:0] B;
    reg CLK;
    reg ENA;
    reg RST;
    wire [17:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .ENA(ENA),
        .RST(RST),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            ENA = 0;
            A = 0;
            B = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 9'd10;
            B = 9'd5;
            ENA = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(18'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            A = 9'd20;
            B = 9'd2;
            ENA = 1;
            @(posedge CLK);
            #1;

            ENA = 0;
            A = 9'd100;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(18'd40);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 9'd15;
            B = 9'd2;
            ENA = 1;
            @(posedge CLK);
            #1;

            B = 9'd10;
            #1;
            #1;

            check_outputs(18'd150);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 9'h1FF;
            B = 9'h1FF;
            ENA = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(18'd261121);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            A = 9'd50;
            B = 9'd2;
            ENA = 1;
            @(posedge CLK);
            #1;

            RST = 1;
            ENA = 1;
            A = 9'd100;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(18'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 9'd255;
            B = 9'd0;
            ENA = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(18'd0);
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
        input [17:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, CLK, ENA, RST, Z);
    end

endmodule
