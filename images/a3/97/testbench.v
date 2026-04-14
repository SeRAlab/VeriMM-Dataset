`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ir;
    wire [3:0] len;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ir(ir),
        .len(len)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase %03d: ir = 0 to 3", test_num);

        ir = 4'b0000; #1;
 check_outputs(4'b0000);
        ir = 4'b0001; #1;
 check_outputs(4'b0000);
        ir = 4'b0010; #1;
 check_outputs(4'b0000);
        ir = 4'b0011; #1;
 check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase %03d: ir = 4 to 7", test_num);

        ir = 4'b0100; #1;
 check_outputs(4'b0000);
        ir = 4'b0101; #1;
 check_outputs(4'b0000);
        ir = 4'b0110; #1;
 check_outputs(4'b0000);
        ir = 4'b0111; #1;
 check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase %03d: ir = 8 to 11", test_num);

        ir = 4'b1000; #1;
 check_outputs(4'b0001);
        ir = 4'b1001; #1;
 check_outputs(4'b0001);
        ir = 4'b1010; #1;
 check_outputs(4'b0001);
        ir = 4'b1011; #1;
 check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase %03d: ir = 12 to 15", test_num);

        ir = 4'b1100; #1;
 check_outputs(4'b0010);
        ir = 4'b1101; #1;
 check_outputs(4'b0010);
        ir = 4'b1110; #1;
 check_outputs(4'b0011);
        ir = 4'b1111; #1;
 check_outputs(4'b0000);
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
        input [3:0] expected_len;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_len === (expected_len ^ len ^ expected_len)) begin
                $display("PASS");
                $display("  Outputs: len=%h",
                         len);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: len=%h",
                         expected_len);
                $display("  Got:      len=%h",
                         len);
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
