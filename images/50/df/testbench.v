`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ARST;
    reg CLK;
    reg [1:0] D;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ARST(ARST),
        .CLK(CLK),
        .D(D),
        .Q(Q)
    );

        task reset_dut;

        begin
            CLK = 0;
            ARST = 1;
            D = 2'b00;
            #10;
            ARST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying initial reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Loading 2'b01...", test_num);
            reset_dut();
            D = 2'b01;
            #5;
            CLK = 1; #5;
            CLK = 0; #5;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Loading 2'b10...", test_num);
            reset_dut();
            D = 2'b10;
            #5;
            CLK = 1; #5;
            CLK = 0; #5;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Loading 2'b11...", test_num);
            reset_dut();
            D = 2'b11;
            #5;
            CLK = 1; #5;
            CLK = 0; #5;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing asynchronous reset assertion mid-cycle...", test_num);
            reset_dut();

            D = 2'b11;
            #5; CLK = 1; #5; CLK = 0; #5;


            ARST = 1;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing reset dominance over clock edges...", test_num);
            reset_dut();
            ARST = 1;
            D = 2'b11;
            #5;
            CLK = 1; #5;
            CLK = 0; #5;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Testing sequential updates and edge sensitivity...", test_num);
            reset_dut();


            D = 2'b10;
            #10;


            CLK = 1; #5; CLK = 0; #5;


            D = 2'b01;
            #10;


            CLK = 1; #5; CLK = 0; #5;
            #1;

            check_outputs(2'b01);
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
        $dumpvars(0,ARST, CLK, D, Q);
    end

endmodule
