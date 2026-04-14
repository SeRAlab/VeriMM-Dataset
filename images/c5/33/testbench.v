`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        a = 0;
        b = 0;
        sel = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication - Positive * Positive (5 * 10)", test_num);
        reset_dut();
        a = 8'sd5;
        b = 8'sd10;
        sel = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(16'sd50);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication - Negative * Positive (-4 * 12)", test_num);
        reset_dut();
        a = -8'sd4;
        b = 8'sd12;
        sel = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(-16'sd48);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication - Negative * Negative (-3 * -7)", test_num);
        reset_dut();
        a = -8'sd3;
        b = -8'sd7;
        sel = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(16'sd21);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication - Zero Case (127 * 0)", test_num);
        reset_dut();
        a = 8'sd127;
        b = 8'sd0;
        sel = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(16'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication - Max Negative (-128 * 2)", test_num);
        reset_dut();
        a = -8'sd128;
        b = 8'sd2;
        sel = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(-16'sd256);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - Positive + Positive (100 + 25)", test_num);
        reset_dut();
        a = 8'sd100;
        b = 8'sd25;
        sel = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(16'sd125);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - Negative + Negative (-50 + -30)", test_num);
        reset_dut();
        a = -8'sd50;
        b = -8'sd30;
        sel = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(-16'sd80);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - Mixed Sign (-128 + 10)", test_num);
        reset_dut();
        a = -8'sd128;
        b = 8'sd10;
        sel = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(-16'sd118);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - Max Positive (127 + 127)", test_num);
        reset_dut();
        a = 8'sd127;
        b = 8'sd127;
        sel = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(16'sd254);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Verification during operation", test_num);
        reset_dut();
        a = 8'sd50;
        b = 8'sd2;
        sel = 0;
        @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(16'b0);
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
        $display("multiplier Testbench");
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,a, b, clk, reset, sel, out);
    end

endmodule
