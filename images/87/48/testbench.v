`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg EN;
    reg KAPWR;
    reg NOTIFIER;
    reg RST_B;
    reg SLEEP_B;
    reg VGND;
    reg VPWR;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .KAPWR(KAPWR),
        .NOTIFIER(NOTIFIER),
        .RST_B(RST_B),
        .SLEEP_B(SLEEP_B),
        .VGND(VGND),
        .VPWR(VPWR),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            D = 0;
            EN = 0;
            SLEEP_B = 1;
            NOTIFIER = 0;
            KAPWR = 1;
            VGND = 0;
            VPWR = 1;
            RST_B = 0;
            #20;
            RST_B = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Capture Data High (EN=1)", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1'b1;
            EN <= 1'b1;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Capture Data Low (EN=1)", test_num);
            reset_dut();


            @(posedge CLK);
            D <= 1'b1;
            EN <= 1'b1;
            @(posedge CLK);


            @(posedge CLK);
            D <= 1'b0;
            EN <= 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable Signal Low (Hold state)", test_num);
            reset_dut();


            @(posedge CLK);
            D <= 1'b1;
            EN <= 1'b1;
            @(posedge CLK);


            @(posedge CLK);
            D <= 1'b0;
            EN <= 1'b0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sleep Mode Active (SLEEP_B=0)", test_num);
            reset_dut();


            @(posedge CLK);
            D <= 1'b1;
            EN <= 1'b1;
            @(posedge CLK);


            SLEEP_B <= 1'b0;
            @(posedge CLK);
            D <= 1'b0;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Asynchronous Reset during operation", test_num);
            reset_dut();


            @(posedge CLK);
            D <= 1'b1;
            EN <= 1'b1;
            @(posedge CLK);
            #2;


            #3;
            RST_B <= 1'b0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Power Supply Loss (VPWR=0)", test_num);
            reset_dut();

            @(posedge CLK);
            D <= 1'b1;
            EN <= 1'b1;
            @(posedge CLK);

            VPWR <= 1'b0;
            #5;

            #1;


            check_outputs(1'bx);
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
        $dumpvars(0,CLK, D, EN, KAPWR, NOTIFIER, RST_B, SLEEP_B, VGND, VPWR, Q);
    end

endmodule
