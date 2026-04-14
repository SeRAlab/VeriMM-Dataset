`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] vec;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vec(vec),
        .count(count)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros", test_num);
        vec = 16'h0000;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All ones", test_num);
        vec = 16'hFFFF;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Alternating bits (0101...)", test_num);
        vec = 16'h5555;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Alternating bits (1010...)", test_num);
        vec = 16'hAAAA;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Single bit (LSB)", test_num);
        vec = 16'h0001;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Single bit (MSB)", test_num);
        vec = 16'h8000;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Half ones, half zeros", test_num);
        vec = 16'hFF00;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Random pattern 1", test_num);
        vec = 16'h1234;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Random pattern 2", test_num);
        vec = 16'hFEDC;
        #1;

        check_outputs(5'd12);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: 15 bits set", test_num);
        vec = 16'h7FFF;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Scattered bits", test_num);
        vec = 16'hC003;
        #1;

        check_outputs(5'd4);
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
        testcase011();
        
        
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
        input [4:0] expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
