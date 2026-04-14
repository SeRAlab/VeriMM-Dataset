`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [3:0] hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .hex(hex)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Binary 0000 -> Hex 0", test_num);
        binary = 4'b0000;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Binary 0101 -> Hex 5", test_num);
        binary = 4'b0101;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Binary 1001 -> Hex 9", test_num);
        binary = 4'b1001;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Binary 1010 -> Hex A", test_num);
        binary = 4'b1010;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Binary 1011 -> Hex B", test_num);
        binary = 4'b1011;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Binary 1100 -> Hex C", test_num);
        binary = 4'b1100;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Binary 1101 -> Hex D", test_num);
        binary = 4'b1101;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Binary 1110 -> Hex E", test_num);
        binary = 4'b1110;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Binary 1111 -> Hex F", test_num);
        binary = 4'b1111;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Binary 0111 -> Hex 7", test_num);
        binary = 4'b0111;
        #1;

        check_outputs(4'h7);
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
        input [3:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
