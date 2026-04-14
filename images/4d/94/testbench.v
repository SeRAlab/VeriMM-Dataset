`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] Exp_X;
    reg [11:0] Exp_Y;
    reg clk;
    reg load_a;
    reg load_b;
    reg rst;
    wire [12:0] Exp_Add;
    wire underflow_f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Exp_X(Exp_X),
        .Exp_Y(Exp_Y),
        .clk(clk),
        .load_a(load_a),
        .load_b(load_b),
        .rst(rst),
        .Exp_Add(Exp_Add),
        .underflow_f(underflow_f)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load_a = 0;
            load_b = 0;
            Exp_X = 0;
            Exp_Y = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            Exp_X = 12'd50;
            Exp_Y = 12'd25;
            load_a = 1;
            load_b = 1;
            @(posedge clk);
            #1;

            check_outputs(13'd75, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            Exp_X = 12'd100;
            Exp_Y = 12'd50;
            load_a = 1;
            load_b = 1;
            @(posedge clk);


            #1;



            check_outputs(13'd150, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            Exp_X = 12'd600;
            Exp_Y = 12'd500;
            load_a = 1;
            load_b = 1;
            @(posedge clk);
            #1;

            check_outputs(13'd1100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            Exp_X = 12'd10;
            Exp_Y = 12'd10;
            load_a = 1;
            load_b = 1;
            @(posedge clk);


            #1;
            Exp_X = 12'd100;
            Exp_Y = 12'd100;
            load_a = 0;
            load_b = 0;
            @(posedge clk);

            #1;


            check_outputs(13'd20, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            Exp_X = 12'd0;
            Exp_Y = 12'd0;
            load_a = 1;
            load_b = 1;
            @(posedge clk);
            #1;

            check_outputs(13'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            Exp_X = 12'hFFF;
            Exp_Y = 12'hFFF;
            load_a = 1;
            load_b = 1;
            @(posedge clk);

            #1;


            check_outputs(13'd8190, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            Exp_X = 12'd100;
            Exp_Y = 12'd100;
            load_a = 1;
            load_b = 1;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1;

            check_outputs(13'd0, 1'b0);
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
        input [12:0] expected_Exp_Add;
        input expected_underflow_f;
        begin
            if (expected_Exp_Add === (expected_Exp_Add ^ Exp_Add ^ expected_Exp_Add) &&
                expected_underflow_f === (expected_underflow_f ^ underflow_f ^ expected_underflow_f)) begin
                $display("PASS");
                $display("  Outputs: Exp_Add=%h, underflow_f=%b",
                         Exp_Add, underflow_f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Exp_Add=%h, underflow_f=%b",
                         expected_Exp_Add, expected_underflow_f);
                $display("  Got:      Exp_Add=%h, underflow_f=%b",
                         Exp_Add, underflow_f);
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
        $dumpvars(0,Exp_X, Exp_Y, clk, load_a, load_b, rst, Exp_Add, underflow_f);
    end

endmodule
