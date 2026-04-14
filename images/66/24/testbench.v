`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] AD;
    reg ALOAD;
    reg CLK;
    reg [1:0] D;
    reg EN;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AD(AD),
        .ALOAD(ALOAD),
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .Q(Q)
    );

        task reset_dut;

        begin
            ALOAD = 1'b1;
            AD = 2'b00;
            EN = 1'b0;
            D = 2'b00;
            #12;
            ALOAD = 1'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            ALOAD = 1'b1;
            AD = 2'b11;
            #5;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            EN = 1'b1;
            D = 2'b10;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            EN = 1'b1;
            D = 2'b11;
            @(posedge CLK);
            #2;

            EN = 1'b0;
            D = 2'b01;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            EN = 1'b1;
            D = 2'b01;

            @(negedge CLK);
            ALOAD = 1'b1;
            AD = 2'b10;
            #2;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            EN = 1'b1;
            D = 2'b01;
            @(posedge CLK);
            #2;
            D = 2'b10;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_Q;
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
        $dumpvars(0,AD, ALOAD, CLK, D, EN, Q);
    end

endmodule
