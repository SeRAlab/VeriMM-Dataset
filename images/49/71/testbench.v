`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg c1;
    reg c2;
    reg [15:0] d1;
    reg [15:0] d2;
    reg s1;
    reg s2;
    wire oc;
    wire [15:0] od;
    wire os;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .c1(c1),
        .c2(c2),
        .d1(d1),
        .d2(d2),
        .s1(s1),
        .s2(s2),
        .oc(oc),
        .od(od),
        .os(os)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            s1 = 0;
            s2 = 0;
            d1 = 16'h0;
            d2 = 16'h0;
            c1 = 0;
            c2 = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            s1 = 1;
            s2 = 0;
            d1 = 16'hABCD;
            d2 = 16'h1234;
            c1 = 1;
            c2 = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 16'hABCD, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            s1 = 0;
            s2 = 1;
            d1 = 16'hAAAA;
            d2 = 16'h5555;
            c1 = 0;
            c2 = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 16'h5555, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            s1 = 1;
            s2 = 1;
            d1 = 16'hF0F0;
            d2 = 16'h0F0F;
            c1 = 1;
            c2 = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 16'hF0F0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            s1 = 0;
            s2 = 0;
            d1 = 16'hFFFF;
            d2 = 16'hEEEE;
            c1 = 1;
            c2 = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(0, 16'h0000, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            s1 = 1;
            s2 = 0;
            d1 = 16'hFFFF;
            c1 = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1, 16'hFFFF, 1);

            s1 = 0;
            s2 = 1;
            d2 = 16'h0000;
            c2 = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 16'h0000, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            s1 = 1; s2 = 0; d1 = 16'h1111; c1 = 1;
            @(posedge CLK);
            #1;

            s1 = 0; s2 = 1; d2 = 16'h2222; c2 = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(0, 16'h2222, 1);
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
        input expected_oc;
        input [15:0] expected_od;
        input expected_os;
        begin
            if (expected_oc === (expected_oc ^ oc ^ expected_oc) &&
                expected_od === (expected_od ^ od ^ expected_od) &&
                expected_os === (expected_os ^ os ^ expected_os)) begin
                $display("PASS");
                $display("  Outputs: oc=%b, od=%h, os=%b",
                         oc, od, os);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oc=%b, od=%h, os=%b",
                         expected_oc, expected_od, expected_os);
                $display("  Got:      oc=%b, od=%h, os=%b",
                         oc, od, os);
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
        $dumpvars(0,CLK, c1, c2, d1, d2, s1, s2, oc, od, os);
    end

endmodule
