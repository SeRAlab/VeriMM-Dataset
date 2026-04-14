`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] cur;
    reg [63:0] in;
    reg shiftIn;
    reg start;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cur(cur),
        .in(in),
        .shiftIn(shiftIn),
        .start(start),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start asserted (Pass-through mode)", test_num);
            in = 64'hAAAA_BBBB_CCCC_DDDD;
            cur = 64'h1111_2222_3333_4444;
            shiftIn = 1'b0;
            start = 1'b1;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start de-asserted, shiftIn=0", test_num);
            in = 64'hAAAA_BBBB_CCCC_DDDD;
            cur = 64'h1111_2222_3333_4444;
            shiftIn = 1'b0;
            start = 1'b0;




            #1;





            check_outputs(64'hAAAA_BBBB_3333_4444);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start de-asserted, shiftIn=1", test_num);
            in = 64'h1234_5678_9ABC_DEF0;
            cur = 64'hFFFF_FFFF_0000_0000;
            shiftIn = 1'b1;
            start = 1'b0;

            #1;


            check_outputs(64'h1234_5678_0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check - All 1s, shift mode", test_num);
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            cur = 64'hFFFF_FFFF_FFFF_FFFF;
            shiftIn = 1'b1;
            start = 1'b0;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check - All 1s, shiftIn=0", test_num);
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            cur = 64'hFFFF_FFFF_FFFF_FFFF;
            shiftIn = 1'b0;
            start = 1'b0;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify LSB replacement logic", test_num);
            in = 64'h0000_0000_0000_0000;
            cur = 64'h0000_0000_0000_0001;
            shiftIn = 1'b0;
            start = 1'b0;


            #1;



            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex data pattern", test_num);
            in  = 64'h5555_AAAA_5555_AAAA;
            cur = 64'hCCCC_3333_CCCC_3333;
            shiftIn = 1'b1;
            start = 1'b0;





            #1;






            check_outputs(64'h5555_AAAA_CCCC_3333);
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
        input [63:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
