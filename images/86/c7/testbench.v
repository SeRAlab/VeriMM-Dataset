`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] InVec;
    reg clk;
    reg load;
    reg reset;
    reg start;
    wire [3:0] OutVec;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InVec(InVec),
        .clk(clk),
        .load(load),
        .reset(reset),
        .start(start),
        .OutVec(OutVec),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            start = 0;
            InVec = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b0001", test_num);
            reset_dut();


            InVec = 4'b0001;
            load = 1;
            @(posedge clk);
            load = 0;


            start = 1;
            @(posedge clk);
            start = 0;


            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(4'b0100, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b0011", test_num);
            reset_dut();

            InVec = 4'b0011;
            load = 1;
            @(posedge clk);
            load = 0;

            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(4'b1100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b1010", test_num);
            reset_dut();

            InVec = 4'b1010;
            load = 1;
            @(posedge clk);
            load = 0;

            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b1111", test_num);
            reset_dut();

            InVec = 4'b1111;
            load = 1;
            @(posedge clk);
            load = 0;

            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(4'b1100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b1100", test_num);
            reset_dut();

            InVec = 4'b1100;
            load = 1;
            @(posedge clk);
            load = 0;

            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 4'b0000", test_num);
            reset_dut();

            InVec = 4'b0000;
            load = 1;
            @(posedge clk);
            load = 0;

            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(4'b0000, 1'b1);
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
        input [3:0] expected_OutVec;
        input expected_done;
        begin
            if (expected_OutVec === (expected_OutVec ^ OutVec ^ expected_OutVec) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: OutVec=%h, done=%b",
                         OutVec, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OutVec=%h, done=%b",
                         expected_OutVec, expected_done);
                $display("  Got:      OutVec=%h, done=%b",
                         OutVec, done);
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
        $dumpvars(0,InVec, clk, load, reset, start, OutVec, done);
    end

endmodule
