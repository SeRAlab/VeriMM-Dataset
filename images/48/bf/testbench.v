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
            ctrl = 5'd0;
            din = 2'd0;
            sel = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0 (Blocked Output)", test_num);
            ctrl = 5'd10;
            din = 2'd3;
            sel = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=0, din=1", test_num);
            ctrl = 5'd0;
            din = 2'd1;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=0, din=3", test_num);
            ctrl = 5'd0;
            din = 2'd3;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=5, din=1", test_num);
            ctrl = 5'd5;
            din = 2'd1;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000020);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=12, din=3", test_num);
            ctrl = 5'd12;
            din = 2'd3;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00003000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=31, din=1", test_num);
            ctrl = 5'd31;
            din = 2'd1;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=30, din=3", test_num);
            ctrl = 5'd30;
            din = 2'd3;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=31, din=2 (Overflow check)", test_num);
            ctrl = 5'd31;
            din = 2'd2;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, ctrl=31, din=3 (Partial overflow)", test_num);
            ctrl = 5'd31;
            din = 2'd3;
            sel = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Blocking check after activity", test_num);

            ctrl = 5'd0; din = 2'd3; sel = 1'b1;
            @(posedge clk);
            #1;

            sel = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
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
