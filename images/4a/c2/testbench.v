`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg [7:0] dfload;
    reg load;
    reg rst;
    wire carry;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .dfload(dfload),
        .load(load),
        .rst(rst),
        .carry(carry),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_ena = 0;
            load = 0;
            dfload = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Load Functionality", test_num);
            reset_dut();

            dfload = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            #1;



            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Basic Counting", test_num);
            reset_dut();

            clk_ena = 1;

            repeat(10) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Clock Enable", test_num);
            reset_dut();

            clk_ena = 0;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Carry at Max Value", test_num);
            reset_dut();


            dfload = 8'hFE;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            clk_ena = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Roll-over", test_num);
            reset_dut();


            dfload = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            clk_ena = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Load Priority", test_num);
            reset_dut();

            clk_ena = 1;
            load = 1;
            dfload = 8'h12;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Sequence", test_num);
            reset_dut();


            dfload = 8'h10;
            load = 1;
            @(posedge clk); #1; load = 0;


            clk_ena = 1;
            repeat(5) @(posedge clk); #1;


            clk_ena = 0;
            repeat(3) @(posedge clk); #1;


            clk_ena = 1;
            repeat(2) @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 8'h17);
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
        input expected_carry;
        input [7:0] expected_dout;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, dout=%h",
                         carry, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, dout=%h",
                         expected_carry, expected_dout);
                $display("  Got:      carry=%b, dout=%h",
                         carry, dout);
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
        $dumpvars(0,clk, clk_ena, dfload, load, rst, carry, dout);
    end

endmodule
