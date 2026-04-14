`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset_l;
    reg [2:0] selectRoute;
    reg tx0_in;
    reg tx1_in;
    reg tx2_in;
    reg tx3_in;
    wire rx0_out;
    wire rx1_out;
    wire rx2_out;
    wire rx3_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset_l(reset_l),
        .selectRoute(selectRoute),
        .tx0_in(tx0_in),
        .tx1_in(tx1_in),
        .tx2_in(tx2_in),
        .tx3_in(tx3_in),
        .rx0_out(rx0_out),
        .rx1_out(rx1_out),
        .rx2_out(rx2_out),
        .rx3_out(rx3_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_l = 0;
            selectRoute = 0;
            tx0_in = 0;
            tx1_in = 0;
            tx2_in = 0;
            tx3_in = 0;
            @(posedge clock);
            #1;
            reset_l = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Reset and Idle State (selectRoute=0)", test_num);
            reset_dut();

            selectRoute = 3'b000;
            tx0_in = 1; tx1_in = 1; tx2_in = 1; tx3_in = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Route tx0_in to rx0_out (selectRoute=1)", test_num);
            reset_dut();
            selectRoute = 3'b001;
            tx0_in = 1; tx1_in = 0; tx2_in = 0; tx3_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Route tx1_in to rx0_out (selectRoute=2)", test_num);
            reset_dut();
            selectRoute = 3'b010;
            tx0_in = 0; tx1_in = 1; tx2_in = 0; tx3_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Route tx2_in to rx0_out (selectRoute=3)", test_num);
            reset_dut();
            selectRoute = 3'b011;
            tx0_in = 0; tx1_in = 0; tx2_in = 1; tx3_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Route tx3_in to rx0_out (selectRoute=4)", test_num);
            reset_dut();
            selectRoute = 3'b100;
            tx0_in = 0; tx1_in = 0; tx2_in = 0; tx3_in = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Route tx0_in to rx1_out (selectRoute=5)", test_num);
            reset_dut();
            selectRoute = 3'b101;
            tx0_in = 1; tx1_in = 0; tx2_in = 0; tx3_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Route tx1_in to rx1_out (selectRoute=6)", test_num);
            reset_dut();
            selectRoute = 3'b110;
            tx0_in = 0; tx1_in = 1; tx2_in = 0; tx3_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Route tx2_in to rx1_out (selectRoute=7)", test_num);
            reset_dut();
            selectRoute = 3'b111;
            tx0_in = 0; tx1_in = 0; tx2_in = 1; tx3_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(0, 1, 0, 0);
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
        testcase008();
        
        
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
        input expected_rx0_out;
        input expected_rx1_out;
        input expected_rx2_out;
        input expected_rx3_out;
        begin
            if (expected_rx0_out === (expected_rx0_out ^ rx0_out ^ expected_rx0_out) &&
                expected_rx1_out === (expected_rx1_out ^ rx1_out ^ expected_rx1_out) &&
                expected_rx2_out === (expected_rx2_out ^ rx2_out ^ expected_rx2_out) &&
                expected_rx3_out === (expected_rx3_out ^ rx3_out ^ expected_rx3_out)) begin
                $display("PASS");
                $display("  Outputs: rx0_out=%b, rx1_out=%b, rx2_out=%b, rx3_out=%b",
                         rx0_out, rx1_out, rx2_out, rx3_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx0_out=%b, rx1_out=%b, rx2_out=%b, rx3_out=%b",
                         expected_rx0_out, expected_rx1_out, expected_rx2_out, expected_rx3_out);
                $display("  Got:      rx0_out=%b, rx1_out=%b, rx2_out=%b, rx3_out=%b",
                         rx0_out, rx1_out, rx2_out, rx3_out);
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
        $dumpvars(0,clock, reset_l, selectRoute, tx0_in, tx1_in, tx2_in, tx3_in, rx0_out, rx1_out, rx2_out, rx3_out);
    end

endmodule
