`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [3:0] D;
    reg LOAD;
    wire [3:0] Q;
    wire [3:0] Q_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .D(D),
        .LOAD(LOAD),
        .Q(Q),
        .Q_next(Q_next)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            LOAD = 0;
            D = 4'b0000;
            @(posedge CLK);
            #1;
            CLR = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            D = 4'b1011;
            LOAD = 1;
            CLR = 0;
            #1;

            #1;


            check_outputs(4'b0000, 4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            D = 4'b1010;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            #1;


            check_outputs(4'b1010, 4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            D = 4'b1111;
            LOAD = 1;
            CLR = 1;
            #1;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            D = 4'b1000;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;


            @(posedge CLK); #1;

            @(posedge CLK); #1;

            @(posedge CLK); #1;


            #1;



            check_outputs(4'b0100, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            D = 4'b1100;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1001, 4'b0011);
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
        input [3:0] expected_Q;
        input [3:0] expected_Q_next;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_next === (expected_Q_next ^ Q_next ^ expected_Q_next)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Q_next=%h",
                         Q, Q_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Q_next=%h",
                         expected_Q, expected_Q_next);
                $display("  Got:      Q=%h, Q_next=%h",
                         Q, Q_next);
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
        $dumpvars(0,CLK, CLR, D, LOAD, Q, Q_next);
    end

endmodule
