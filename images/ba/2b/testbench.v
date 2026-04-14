`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg enable;
    reg [15:0] i_in;
    reg [15:0] q_in;
    reg reset;
    wire [15:0] i_out_ana;
    wire i_out_dig;
    wire [15:0] q_out_ana;
    wire q_out_dig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .i_in(i_in),
        .q_in(q_in),
        .reset(reset),
        .i_out_ana(i_out_ana),
        .i_out_dig(i_out_dig),
        .q_out_ana(q_out_ana),
        .q_out_dig(q_out_dig)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable High - i_in=0xAAAA, q_in=0x5555", test_num);
            reset = 1; enable = 0; i_in = 0; q_in = 0;
            #10; reset = 0;
            @(posedge clock);
            enable = 1;
            i_in = 16'hAAAA;
            q_in = 16'h5555;
            @(posedge clock);



            #1;




            check_outputs(16'h5555, 1'b0, 16'h2AAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Low - Inputs set to Max", test_num);
            reset = 1; enable = 0; i_in = 0; q_in = 0;
            #10; reset = 0;
            @(posedge clock);
            enable = 0;
            i_in = 16'hFFFF;
            q_in = 16'hFFFF;
            @(posedge clock);

            #1;


            check_outputs(16'h0000, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable High - LSB logic check", test_num);
            reset = 1; enable = 0; i_in = 0; q_in = 0;
            #10; reset = 0;
            @(posedge clock);
            enable = 1;
            i_in = 16'h0001;
            q_in = 16'h8001;
            @(posedge clock);



            #1;




            check_outputs(16'h0000, 1'b1, 16'h4000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable High - Boundary 0xFFFF", test_num);
            reset = 1; enable = 0; i_in = 0; q_in = 0;
            #10; reset = 0;
            @(posedge clock);
            enable = 1;
            i_in = 16'hFFFF;
            q_in = 16'hFFFF;
            @(posedge clock);



            #1;




            check_outputs(16'h7FFF, 1'b1, 16'h7FFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable High - MSB shifting into zero", test_num);
            reset = 1; enable = 0; i_in = 0; q_in = 0;
            #10; reset = 0;
            @(posedge clock);
            enable = 1;
            i_in = 16'h8000;
            q_in = 16'h0000;
            @(posedge clock);



            #1;




            check_outputs(16'h4000, 1'b0, 16'h0000, 1'b0);
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
        input [15:0] expected_i_out_ana;
        input expected_i_out_dig;
        input [15:0] expected_q_out_ana;
        input expected_q_out_dig;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_out_ana === (expected_i_out_ana ^ i_out_ana ^ expected_i_out_ana) &&
                expected_i_out_dig === (expected_i_out_dig ^ i_out_dig ^ expected_i_out_dig) &&
                expected_q_out_ana === (expected_q_out_ana ^ q_out_ana ^ expected_q_out_ana) &&
                expected_q_out_dig === (expected_q_out_dig ^ q_out_dig ^ expected_q_out_dig)) begin
                $display("PASS");
                $display("  Outputs: i_out_ana=%h, i_out_dig=%b, q_out_ana=%h, q_out_dig=%b",
                         i_out_ana, i_out_dig, q_out_ana, q_out_dig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_out_ana=%h, i_out_dig=%b, q_out_ana=%h, q_out_dig=%b",
                         expected_i_out_ana, expected_i_out_dig, expected_q_out_ana, expected_q_out_dig);
                $display("  Got:      i_out_ana=%h, i_out_dig=%b, q_out_ana=%h, q_out_dig=%b",
                         i_out_ana, i_out_dig, q_out_ana, q_out_dig);
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

endmodule
