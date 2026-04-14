`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] bx;
    reg [9:0] by;
    reg cclk;
    reg [9:0] pbot;
    reg [9:0] ptop;
    reg reset;
    wire collide;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bx(bx),
        .by(by),
        .cclk(cclk),
        .pbot(pbot),
        .ptop(ptop),
        .reset(reset),
        .collide(collide)
    );

    // Clock generation (10ns period)
    initial begin
        cclk = 0;
        forever #5 cclk = ~cclk;
    end

        task reset_dut;

    begin
        reset = 1;
        bx = 0; by = 0; ptop = 0; pbot = 0;
        @(posedge cclk);
        #2 reset = 0;
        @(posedge cclk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %03d: Reset Check", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test %03d: Inside Rectangle (Center)", test_num);
        bx = 325; by = 200; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test %03d: Outside - X too low", test_num);
        bx = 100; by = 200; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test %03d: Outside - X too high", test_num);
        bx = 400; by = 200; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test %03d: Outside - Y above ptop", test_num);
        bx = 325; by = 50; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Test %03d: Outside - Y below pbot", test_num);
        bx = 325; by = 350; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Test %03d: Clock Low Output Check", test_num);
        bx = 325; by = 200; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        @(negedge cclk); #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        $display("Test %03d: Boundary Check - X Min", test_num);
        bx = 300; by = 200; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        $display("Test %03d: Boundary Check - X Max", test_num);
        bx = 350; by = 200; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        $display("Test %03d: Async Reset during active collision", test_num);
        bx = 325; by = 200; ptop = 100; pbot = 300;
        @(posedge cclk); #1;
        reset = 1; #1;
        #1;

        check_outputs(0);
        reset = 0;
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
        testcase009();
        testcase010();
        
        
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
        input expected_collide;
        begin
            if (expected_collide === (expected_collide ^ collide ^ expected_collide)) begin
                $display("PASS");
                $display("  Outputs: collide=%b",
                         collide);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: collide=%b",
                         expected_collide);
                $display("  Got:      collide=%b",
                         collide);
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
        $dumpvars(0,bx, by, cclk, pbot, ptop, reset, collide);
    end

endmodule
