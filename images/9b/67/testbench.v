`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [1:0] ctrl;
    reg din;
    reg rst;
    reg set;
    wire dout;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .ctrl(ctrl),
        .din(din),
        .rst(rst),
        .set(set),
        .dout(dout),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        din = 0;
        set = 0;
        clr = 0;
        ctrl = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Initial Reset", test_num);
        reset_dut();
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Data Mode - Load 1", test_num);
        reset_dut();
        ctrl = 2'b00;
        din = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Data Mode - Load 0", test_num);
        reset_dut();

        ctrl = 2'b00; din = 1; @(posedge clk);

        din = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: JK Mode - Toggle (0->1)", test_num);
        reset_dut();
        ctrl = 2'b01;
        set = 1;
        clr = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: JK Mode - Toggle (1->0)", test_num);
        reset_dut();

        ctrl = 2'b00; din = 1; @(posedge clk);

        ctrl = 2'b01; set = 1; clr = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: JK Mode - Set", test_num);
        reset_dut();
        ctrl = 2'b01;
        set = 1; clr = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: T Mode - Toggle (0->1)", test_num);
        reset_dut();
        ctrl = 2'b10;
        din = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: T Mode - Hold", test_num);
        reset_dut();
        ctrl = 2'b00; din = 1; @(posedge clk);
        ctrl = 2'b10; din = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: SR Mode - Set", test_num);
        reset_dut();
        ctrl = 2'b11;
        set = 1; clr = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: SR Mode - Clear", test_num);
        reset_dut();
        ctrl = 2'b00; din = 1; @(posedge clk);
        ctrl = 2'b11; set = 0; clr = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(0, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: SR Mode - Hold", test_num);
        reset_dut();
        ctrl = 2'b00; din = 1; @(posedge clk);
        ctrl = 2'b11; set = 0; clr = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Mode Transition - Data to JK Hold", test_num);
        reset_dut();
        ctrl = 2'b00; din = 1; @(posedge clk);
        ctrl = 2'b01; set = 0; clr = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 1);
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
        testcase011();
        testcase012();
        
        
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
        input expected_dout;
        input expected_q;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: dout=%b, q=%b",
                         dout, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b, q=%b",
                         expected_dout, expected_q);
                $display("  Got:      dout=%b, q=%b",
                         dout, q);
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
        $dumpvars(0,clk, clr, ctrl, din, rst, set, dout, q);
    end

endmodule
