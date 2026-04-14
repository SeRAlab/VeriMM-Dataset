`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] I_par;
    reg LSB_in;
    reg MSB_in;
    reg clk;
    reg rstn;
    reg [1:0] sel;
    wire [3:0] A_par;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_par(I_par),
        .LSB_in(LSB_in),
        .MSB_in(MSB_in),
        .clk(clk),
        .rstn(rstn),
        .sel(sel),
        .A_par(A_par)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            clk = 0;
            I_par = 0;
            LSB_in = 0;
            MSB_in = 0;
            sel = 0;
            #15 rstn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load", test_num);
            reset_dut();
            @(negedge clk);
            sel = 2'b11;
            I_par = 4'hA;
            @(negedge clk);
            sel = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right", test_num);
            reset_dut();

            @(negedge clk);
            sel = 2'b11;
            I_par = 4'hF;
            @(negedge clk);

            sel = 2'b01;
            MSB_in = 0;
            @(negedge clk);
            sel = 2'b00;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left", test_num);
            reset_dut();

            @(negedge clk);
            sel = 2'b11;
            I_par = 4'hF;
            @(negedge clk);

            sel = 2'b10;
            LSB_in = 0;
            @(negedge clk);
            sel = 2'b00;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Mode", test_num);
            reset_dut();
            @(negedge clk);
            sel = 2'b11;
            I_par = 4'h5;
            @(negedge clk);
            sel = 2'b00;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Shift Right", test_num);
            reset_dut();
            @(negedge clk);
            sel = 2'b01;
            MSB_in = 1;
            @(negedge clk);
            MSB_in = 1;
            @(negedge clk);
            MSB_in = 0;
            @(negedge clk);
            sel = 2'b00;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Shift Left", test_num);
            reset_dut();
            @(negedge clk);
            sel = 2'b10;
            LSB_in = 1;
            @(negedge clk);
            LSB_in = 0;
            @(negedge clk);
            LSB_in = 1;
            @(negedge clk);
            sel = 2'b00;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();
            @(negedge clk);
            sel = 2'b11;
            I_par = 4'hF;
            @(negedge clk);
            rstn = 0;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Sequence", test_num);
            reset_dut();
            @(negedge clk);
            sel = 2'b11; I_par = 4'b0110;
            @(negedge clk);
            sel = 2'b10; LSB_in = 1;
            @(negedge clk);
            sel = 2'b01; MSB_in = 0;
            @(negedge clk);
            sel = 2'b00;
            #1;

            check_outputs(4'h6);
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
        input [3:0] expected_A_par;
        begin
            if (expected_A_par === (expected_A_par ^ A_par ^ expected_A_par)) begin
                $display("PASS");
                $display("  Outputs: A_par=%h",
                         A_par);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_par=%h",
                         expected_A_par);
                $display("  Got:      A_par=%h",
                         A_par);
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
        $dumpvars(0,I_par, LSB_in, MSB_in, clk, rstn, sel, A_par);
    end

endmodule
