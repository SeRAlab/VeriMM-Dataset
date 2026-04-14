`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] block_in;
    reg [6:0] length;
    wire [127:0] block_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .block_in(block_in),
        .length(length),
        .block_out(block_out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Length 0");
        test_num = test_num + 1;
        length = 7'd0;
        block_in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;


        #1;



        check_outputs(128'h1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Length 1");
        test_num = test_num + 1;
        length = 7'd1;
        block_in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;


        #1;



        check_outputs(128'h3);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Length 8");
        test_num = test_num + 1;
        length = 7'd8;
        block_in = 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA;



        #1;




        check_outputs(128'h1AA);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Length 64");
        test_num = test_num + 1;
        length = 7'd64;
        block_in = 128'h5555_5555_5555_5555_5555_5555_5555_5555;


        #1;



        check_outputs(128'h1_5555_5555_5555_5555);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Length 127");
        test_num = test_num + 1;
        length = 7'd127;
        block_in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;


        #1;



        check_outputs(128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Clearing unused bits");
        test_num = test_num + 1;
        length = 7'd4;
        block_in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;


        #1;



        check_outputs(128'h1F);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Patterned block_in");
        test_num = test_num + 1;
        length = 7'd12;
        block_in = 128'hDEADC0DE_BEEFCAFE_FEEDFACE_CAFEBABE;



        #1;




        check_outputs(128'h1ABE);
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
        input [127:0] expected_block_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_block_out === (expected_block_out ^ block_out ^ expected_block_out)) begin
                $display("PASS");
                $display("  Outputs: block_out=%h",
                         block_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: block_out=%h",
                         expected_block_out);
                $display("  Got:      block_out=%h",
                         block_out);
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
