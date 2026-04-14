`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg C;
    reg S;
    reg clk;
    reg enable;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S),
        .clk(clk),
        .enable(enable),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1;
            S = 0;
            A = 0; B = 0; C = 0;
            repeat(8) @(posedge clk);
            enable = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Load 1 to Index 0", test_num);
            reset_dut();
            @(negedge clk);
            S = 1; enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            {A, B, C} = 3'b000;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Shift 1 to Index 7", test_num);
            reset_dut();
            @(negedge clk);

            S = 1; enable = 1;
            @(posedge clk);

            S = 0;
            repeat(7) @(posedge clk);
            #1;
            enable = 0;
            {A, B, C} = 3'b111;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Check Enable Control", test_num);
            reset_dut();
            @(negedge clk);

            S = 1; enable = 1;
            @(posedge clk);

            S = 0; enable = 0;
            @(posedge clk);
            #1;
            {A, B, C} = 3'b000;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Pattern 10101010 Index 2", test_num);
            reset_dut();
            pattern = 8'b10101010;
            @(negedge clk);
            enable = 1;
            for(i=7; i>=0; i=i-1) begin
                S = pattern[i];
                @(posedge clk);
            end
            #1;
            enable = 0;
            {A, B, C} = 3'b010;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Pattern 11001100 Index 5", test_num);
            reset_dut();
            pattern = 8'b11001100;
            @(negedge clk);
            enable = 1;
            for(i=7; i>=0; i=i-1) begin
                S = pattern[i];
                @(posedge clk);
            end
            #1;
            enable = 0;
            {A, B, C} = 3'b101;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Fill 1s Index 3", test_num);
            reset_dut();
            @(negedge clk);
            S = 1; enable = 1;
            repeat(8) @(posedge clk);
            #1;
            enable = 0;
            {A, B, C} = 3'b011;
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
        $dumpvars(0,A, B, C, S, clk, enable, Z);
    end

endmodule
