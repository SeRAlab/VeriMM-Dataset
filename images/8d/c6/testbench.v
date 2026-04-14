`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] b_in;
    reg clk;
    wire [127:0] b_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b_in(b_in),
        .clk(clk),
        .b_out(b_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Incremental values 00..0F", test_num);
        b_in = 128'h000102030405060708090a0b0c0d0e0f;
        @(posedge clk);

        #1;


        check_outputs(128'h00050a0f04090e03080d02070c01060b);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        b_in = 128'h0;
        @(posedge clk);
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Ones", test_num);
        b_in = {128{1'b1}};
        @(posedge clk);
        #1;

        check_outputs({128{1'b1}});
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Row-invariant pattern", test_num);


        b_in = 128'haabbccddaabbccddaabbccddaabbccdd;
        @(posedge clk);

        #1;


        check_outputs(128'haabbccddaabbccddaabbccddaabbccdd);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Complex sequence", test_num);
        b_in = 128'h00112233445566778899aabbccddeeff;
        @(posedge clk);





        #1;






        check_outputs(128'h0055aaff4499ee3388dd2277cc1166bb);
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
        input [127:0] expected_b_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out)) begin
                $display("PASS");
                $display("  Outputs: b_out=%h",
                         b_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%h",
                         expected_b_out);
                $display("  Got:      b_out=%h",
                         b_out);
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
