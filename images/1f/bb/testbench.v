`timescale 1ns/1ps

module IIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in0;
    reg [15:0] in1;
    reg rst;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IIR_Filter dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in0 = 0;
            in1 = 0;
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
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Impulse Response - Short Sequence", test_num);
            reset_dut();


            in0 = 16'd100; in1 = 0;
            @(posedge clk); #1;


            in0 = 0; in1 = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h000E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Dual Input Summation Check", test_num);
            reset_dut();


            in0 = 16'd50; in1 = 16'd50;
            @(posedge clk); #1;


            in0 = 0; in1 = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h000E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Step Response (2 Cycles)", test_num);
            reset_dut();

            in0 = 16'd1000; in1 = 0;
            @(posedge clk); #1;
            in0 = 16'd1000; in1 = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 4th Order State Propagation", test_num);
            reset_dut();

            in0 = 16'd200; in1 = 0;
            @(posedge clk); #1;
            in0 = 0; @(posedge clk); #1;
            in0 = 0; @(posedge clk); #1;
            in0 = 0; @(posedge clk); #1;
            in0 = 0; @(posedge clk); #1;

            #1;


            check_outputs(16'h0017);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Mid-Operation", test_num);
            reset_dut();

            in0 = 16'hFFFF; in1 = 16'hFFFF;
            @(posedge clk); @(posedge clk);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IIR_Filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, in0, in1, rst, out);
    end

endmodule
