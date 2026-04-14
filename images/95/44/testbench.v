`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg addcontrol;
    reg clk;
    reg control;
    reg [31:0] inc;
    reg push;
    reg reset;
    wire [31:0] addr;
    wire next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addcontrol(addcontrol),
        .clk(clk),
        .control(control),
        .inc(inc),
        .push(push),
        .reset(reset),
        .addr(addr),
        .next(next)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            push = 0;
            addcontrol = 0;
            inc = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Increment (push)", test_num);
            reset_dut();
            inc = 32'd10;
            control = 1;
            push = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Increment (addcontrol)", test_num);
            reset_dut();
            inc = 32'd25;
            control = 1;
            addcontrol = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd26, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple Sequential Increments", test_num);
            reset_dut();
            control = 1;
            push = 1;


            inc = 32'd5;
            @(posedge clk);
            #1;


            inc = 32'd2;
            @(posedge clk);
            #1;


            inc = 32'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Control Signal Gating", test_num);
            reset_dut();
            inc = 32'hAAAA;
            control = 0;
            push = 1;
            addcontrol = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Push/AddControl Gating", test_num);
            reset_dut();
            inc = 32'h5555;
            control = 1;
            push = 0;
            addcontrol = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Address Wrap-around", test_num);
            reset_dut();


            inc = 32'hFFFFFFFF;
            control = 1;
            push = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Large Value Increment", test_num);
            reset_dut();

            inc = 32'h10000000;
            control = 1;
            push = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h10000001, 1'b1);
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
        input [31:0] expected_addr;
        input expected_next;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_next === (expected_next ^ next ^ expected_next)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, next=%b",
                         addr, next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, next=%b",
                         expected_addr, expected_next);
                $display("  Got:      addr=%h, next=%b",
                         addr, next);
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
        $dumpvars(0,addcontrol, clk, control, inc, push, reset, addr, next);
    end

endmodule
