`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg addnsub;
    reg aload;
    reg clk;
    reg [6:0] offset;
    reg [6:0] offsetdelayctrlin;
    wire [6:0] offsetctrlout;
    wire [6:0] offsettestout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addnsub(addnsub),
        .aload(aload),
        .clk(clk),
        .offset(offset),
        .offsetdelayctrlin(offsetdelayctrlin),
        .offsetctrlout(offsetctrlout),
        .offsettestout(offsettestout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addnsub = 0;
            aload = 0;
            offset = 0;
            offsetdelayctrlin = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Basic Addition", test_num);
            reset_dut();

            offsetdelayctrlin = 7'd40;
            offset = 7'd20;
            addnsub = 1'b1;
            aload = 1'b1;

            @(posedge clk);
            #1;
            aload = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'd60, 7'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Basic Subtraction", test_num);
            reset_dut();

            offsetdelayctrlin = 7'd50;
            offset = 7'd15;
            addnsub = 1'b0;
            aload = 1'b1;

            @(posedge clk);
            #1;
            aload = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'd35, 7'd35);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Load Enable Check", test_num);
            reset_dut();


            offsetdelayctrlin = 7'd10;
            offset = 7'd5;
            addnsub = 1'b1;
            aload = 1'b1;
            @(posedge clk);
            #1;


            offsetdelayctrlin = 7'd100;
            offset = 7'd20;
            aload = 1'b0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(7'd15, 7'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Maximum Value Check", test_num);
            reset_dut();

            offsetdelayctrlin = 7'd127;
            offset = 7'd0;
            addnsub = 1'b1;
            aload = 1'b1;

            @(posedge clk);
            #1;
            aload = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'd127, 7'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Overflow Wrap-around", test_num);
            reset_dut();

            offsetdelayctrlin = 7'd100;
            offset = 7'd40;
            addnsub = 1'b1;
            aload = 1'b1;

            @(posedge clk);
            #1;
            aload = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'd12, 7'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Underflow Wrap-around", test_num);
            reset_dut();

            offsetdelayctrlin = 7'd10;
            offset = 7'd20;
            addnsub = 1'b0;
            aload = 1'b1;

            @(posedge clk);
            #1;
            aload = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'd118, 7'd118);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Zero Result Check", test_num);
            reset_dut();

            offsetdelayctrlin = 7'd64;
            offset = 7'd64;
            addnsub = 1'b0;
            aload = 1'b1;

            @(posedge clk);
            #1;
            aload = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'd0, 7'd0);
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
        input [6:0] expected_offsetctrlout;
        input [6:0] expected_offsettestout;
        begin
            if (expected_offsetctrlout === (expected_offsetctrlout ^ offsetctrlout ^ expected_offsetctrlout) &&
                expected_offsettestout === (expected_offsettestout ^ offsettestout ^ expected_offsettestout)) begin
                $display("PASS");
                $display("  Outputs: offsetctrlout=%h, offsettestout=%h",
                         offsetctrlout, offsettestout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: offsetctrlout=%h, offsettestout=%h",
                         expected_offsetctrlout, expected_offsettestout);
                $display("  Got:      offsetctrlout=%h, offsettestout=%h",
                         offsetctrlout, offsettestout);
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
        $dumpvars(0,addnsub, aload, clk, offset, offsetdelayctrlin, offsetctrlout, offsettestout);
    end

endmodule
