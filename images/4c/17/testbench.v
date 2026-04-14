`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] vec;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] outv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .outv(outv)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            vec = 3'b000;

            repeat(4) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Input 3'b101", test_num);
            reset_dut();
            @(negedge clk);
            vec = 3'b101;

            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 1, 3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Input 3'b011", test_num);
            reset_dut();
            @(negedge clk);
            vec = 3'b011;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 1, 0, 3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Input 3'b111", test_num);
            reset_dut();
            @(negedge clk);
            vec = 3'b111;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 1, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Input 3'b000", test_num);
            reset_dut();

            @(negedge clk);
            vec = 3'b111;
            repeat(3) @(posedge clk);

            @(negedge clk);
            vec = 3'b000;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Input 3'b110", test_num);
            reset_dut();
            @(negedge clk);
            vec = 3'b110;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 1, 3'b110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Pipeline Shift Verification", test_num);
            reset_dut();

            @(negedge clk);
            vec = 3'b001;
            @(negedge clk);
            vec = 3'b010;
            @(negedge clk);
            vec = 3'b100;
            @(negedge clk);
            vec = 3'b111;
            #2;

            #1;


            check_outputs(1, 1, 1, 3'b001);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_outv;
        begin
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, outv=%h",
                         o0, o1, o2, outv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, outv=%h",
                         expected_o0, expected_o1, expected_o2, expected_outv);
                $display("  Got:      o0=%b, o1=%b, o2=%b, outv=%h",
                         o0, o1, o2, outv);
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
        $dumpvars(0,clk, vec, o0, o1, o2, outv);
    end

endmodule
