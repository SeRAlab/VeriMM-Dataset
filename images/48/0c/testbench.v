`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR1;
    reg [3:0] D1;
    reg [3:0] D2;
    reg EN2;
    reg PL1;
    reg PL2;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR1(CLR1),
        .D1(D1),
        .D2(D2),
        .EN2(EN2),
        .PL1(PL1),
        .PL2(PL2),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR1 = 1;
            PL1  = 0;
            PL2  = 0;
            EN2  = 0;
            D1   = 4'b0000;
            D2   = 4'b0000;

            @(posedge CLK);
            #1;
            CLR1 = 0;

            PL2  = 1;
            D2   = 4'b0000;
            @(negedge CLK);
            #1;
            PL2  = 0;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Parallel Load reg1");
            reset_dut();
            D1 = 4'b1011;
            PL1 = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b1011_0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Synchronous Clear reg1");
            reset_dut();

            D1 = 4'b1111;
            PL1 = 1;
            @(posedge CLK);
            #1;
            PL1 = 0;
            CLR1 = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Shift Left reg1");
            reset_dut();

            D1 = 4'b0101;
            PL1 = 1;
            @(posedge CLK);
            #1;
            PL1 = 0;

            @(posedge CLK);

            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'b0100_0000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Parallel Load reg2");
            reset_dut();
            D2 = 4'b1101;
            PL2 = 1;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(8'b0000_1101);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Shift reg2 from D2");
            reset_dut();

            D2 = 4'b0001;
            PL2 = 1;
            @(negedge CLK);
            #1;
            PL2 = 0;
            EN2 = 1;
            D2 = 4'b0001;

            @(negedge CLK);

            @(negedge CLK);
            #2;
            #1;

            check_outputs(8'b0000_0111);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Combined reg1 and reg2 operations");
            reset_dut();

            PL1 = 1; D1 = 4'b1001;
            @(posedge CLK);
            #1; PL1 = 0;


            PL2 = 1; D2 = 4'b0110;
            @(negedge CLK);
            #1; PL2 = 0;




            @(posedge CLK);

            EN2 = 1; D2 = 4'b0001;
            @(negedge CLK);

            #2;
            #1;

            check_outputs(8'b0010_1101);
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
        input [7:0] expected_Q;
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
        $dumpvars(0,CLK, CLR1, D1, D2, EN2, PL1, PL2, Q);
    end

endmodule
