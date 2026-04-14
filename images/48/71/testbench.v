`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in_addr;
    wire [4:0] out_word;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_addr(in_addr),
        .out_word(out_word)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h00", test_num);
        in_addr = 5'h00;


        #1;



        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h01", test_num);
        in_addr = 5'h01;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h07", test_num);
        in_addr = 5'h07;
        #1;

        check_outputs(5'h07);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h08", test_num);
        in_addr = 5'h08;
        #1;

        check_outputs(5'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h0F", test_num);
        in_addr = 5'h0F;
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h10", test_num);
        in_addr = 5'h10;
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h18", test_num);
        in_addr = 5'h18;
        #1;

        check_outputs(5'h18);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 5'h1F", test_num);
        in_addr = 5'h1F;
        #1;

        check_outputs(5'h1F);
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
        input [4:0] expected_out_word;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_word === (expected_out_word ^ out_word ^ expected_out_word)) begin
                $display("PASS");
                $display("  Outputs: out_word=%h",
                         out_word);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_word=%h",
                         expected_out_word);
                $display("  Got:      out_word=%h",
                         out_word);
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
