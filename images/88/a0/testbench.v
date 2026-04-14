`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ictmr_i;
    reg [31:0] timer1_i;
    reg [31:0] timer2_i;
    wire [31:0] tval_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ictmr_i(ictmr_i),
        .timer1_i(timer1_i),
        .timer2_i(timer2_i),
        .tval_o(tval_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ictmr_i = 0 (Select timer1_i)", test_num);
            ictmr_i = 2'h0;
            timer1_i = 32'hAAAA_BBBB;
            timer2_i = 32'h1111_2222;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ictmr_i = 1 (Select timer1_i)", test_num);
            ictmr_i = 2'h1;
            timer1_i = 32'hCCCC_DDDD;
            timer2_i = 32'h3333_4444;
            #1;

            check_outputs(32'hCCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ictmr_i = 2 (Select timer2_i)", test_num);
            ictmr_i = 2'h2;
            timer1_i = 32'hEEEE_FFFF;
            timer2_i = 32'h5555_6666;
            #1;

            check_outputs(32'h5555_6666);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ictmr_i = 3 (Select timer1_i)", test_num);
            ictmr_i = 2'h3;
            timer1_i = 32'h7777_8888;
            timer2_i = 32'h9999_0000;
            #1;

            check_outputs(32'h7777_8888);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Edge case zeros with ictmr_i = 2", test_num);
            ictmr_i = 2'h2;
            timer1_i = 32'hFFFF_FFFF;
            timer2_i = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Edge case all ones with ictmr_i = 0", test_num);
            ictmr_i = 2'h0;
            timer1_i = 32'hFFFF_FFFF;
            timer2_i = 32'h0000_0000;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_tval_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tval_o === (expected_tval_o ^ tval_o ^ expected_tval_o)) begin
                $display("PASS");
                $display("  Outputs: tval_o=%h",
                         tval_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tval_o=%h",
                         expected_tval_o);
                $display("  Got:      tval_o=%h",
                         tval_o);
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
