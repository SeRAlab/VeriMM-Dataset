`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_N;
    reg D;
    reg RESET_B;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_N(CLK_N),
        .D(D),
        .RESET_B(RESET_B),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_N = 0;
        forever #5 CLK_N = ~CLK_N;
    end

        task reset_dut;

        begin

            VPWR = 1;
            VGND = 0;
            VPB  = 1;
            VNB  = 0;


            RESET_B = 0;
            D = 0;
            #15;
            RESET_B = 1;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Async Reset Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: D=1 transfer on rising edge", test_num);
            reset_dut();

            @(negedge CLK_N);
            D = 1;
            @(posedge CLK_N);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: D=0 transfer on rising edge", test_num);
            reset_dut();


            @(negedge CLK_N);
            D = 1;
            @(posedge CLK_N);


            @(negedge CLK_N);
            D = 0;
            @(posedge CLK_N);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Asynchronous reset mid-cycle", test_num);
            reset_dut();


            @(negedge CLK_N);
            D = 1;
            @(posedge CLK_N);
            #2;


            #3;
            RESET_B = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verify no change on falling edge", test_num);
            reset_dut();


            @(posedge CLK_N);
            #1;
            D = 1;
            @(negedge CLK_N);
            #2;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Data stability without clock edges", test_num);
            reset_dut();

            @(negedge CLK_N);
            D = 1;
            @(posedge CLK_N);
            #2;

            D = 0;
            #2;

            #1;


            check_outputs(1'b1);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,CLK_N, D, RESET_B, VGND, VNB, VPB, VPWR, Q);
    end

endmodule
