`timescale 1ns/1ps

module binary_to_bcd_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [3:0] bcd0;
    wire [3:0] bcd1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_bcd dut (
        .binary(binary),
        .bcd0(bcd0),
        .bcd1(bcd1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Binary = 0", test_num);
        binary = 4'd0;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Binary = 5", test_num);
        binary = 4'd5;
        #1;

        check_outputs(4'h5, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Binary = 9", test_num);
        binary = 4'd9;
        #1;

        check_outputs(4'h9, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Binary = 10", test_num);
        binary = 4'd10;
        #1;

        check_outputs(4'h0, 4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Binary = 13", test_num);
        binary = 4'd13;
        #1;

        check_outputs(4'h3, 4'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Binary = 15", test_num);
        binary = 4'd15;
        #1;

        check_outputs(4'h5, 4'h1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Binary = 8", test_num);
        binary = 4'd8;
        #1;

        check_outputs(4'h8, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Binary = 11", test_num);
        binary = 4'd11;
        #1;

        check_outputs(4'h1, 4'h1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_bcd Testbench");
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
        input [3:0] expected_bcd0;
        input [3:0] expected_bcd1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd0 === (expected_bcd0 ^ bcd0 ^ expected_bcd0) &&
                expected_bcd1 === (expected_bcd1 ^ bcd1 ^ expected_bcd1)) begin
                $display("PASS");
                $display("  Outputs: bcd0=%h, bcd1=%h",
                         bcd0, bcd1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd0=%h, bcd1=%h",
                         expected_bcd0, expected_bcd1);
                $display("  Got:      bcd0=%h, bcd1=%h",
                         bcd0, bcd1);
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
