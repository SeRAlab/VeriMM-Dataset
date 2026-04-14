`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ctrl;
    reg [1:0] din;
    reg sel;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .din(din),
        .sel(sel),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 5'b0;
            din = 2'b0;
            sel = 1'b0;
            @(posedge clk);
            #1;


        end
        endtask
    task simulate_step;

        input [4:0] i_ctrl;
        input [1:0] i_din;
        input i_sel;
        reg [1:0] c;
        integer a, b, prod;
        begin
            ctrl = i_ctrl;
            din = i_din;
            sel = i_sel;



            c = ~i_din;

            a = i_ctrl[4:3];
            b = i_ctrl[2:0];
            prod = a * b;

            @(posedge clk);
            #1;


            expected_val = expected_val + 1;




            if (i_sel == 0)
                expected_val[ (prod % 16) * 2 +: 2] = c;
            else
                expected_val[ ((prod + 4) % 16) * 2 +: 2] = c;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic operation (prod=0, sel=0)", test_num);
            reset_dut();
            expected_val = 0;
            simulate_step(5'b00000, 2'b00, 1'b0);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data variation (din=2'b11 -> c=2'b00)", test_num);

            simulate_step(5'b00000, 2'b11, 1'b0);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control variation (a=1, b=1 -> prod=1)", test_num);
            simulate_step(5'b01001, 2'b01, 1'b0);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sel positioning control (sel=1)", test_num);
            simulate_step(5'b00000, 2'b10, 1'b1);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large product and overflow check", test_num);
            simulate_step(5'b11111, 2'b00, 1'b0);
            #1;

            check_outputs(expected_val);
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
        input [31:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, ctrl, din, sel, dout);
    end

endmodule
