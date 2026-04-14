`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ascii;
    wire [31:0] number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ascii(ascii),
        .number(number)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: ASCII '0'", test_num);
        ascii = 8'h30;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: ASCII '1'", test_num);
        ascii = 8'h31;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: ASCII '2'", test_num);
        ascii = 8'h32;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: ASCII '3'", test_num);
        ascii = 8'h33;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: ASCII '4'", test_num);
        ascii = 8'h34;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: ASCII '5'", test_num);
        ascii = 8'h35;
        #1;

        check_outputs(32'h00000005);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: ASCII '6'", test_num);
        ascii = 8'h36;
        #1;

        check_outputs(32'h00000006);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: ASCII '7'", test_num);
        ascii = 8'h37;
        #1;

        check_outputs(32'h00000007);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: ASCII '8'", test_num);
        ascii = 8'h38;
        #1;

        check_outputs(32'h00000008);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: ASCII '9'", test_num);
        ascii = 8'h39;
        #1;

        check_outputs(32'h00000009);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_number;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_number === (expected_number ^ number ^ expected_number)) begin
                $display("PASS");
                $display("  Outputs: number=%h",
                         number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: number=%h",
                         expected_number);
                $display("  Got:      number=%h",
                         number);
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
