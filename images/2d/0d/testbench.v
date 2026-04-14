`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    wire [19:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data(data),
        .encoded(encoded)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: All Zeros", test_num);
        data = 16'h0000;
        #10;
        #1;

        check_outputs(calculate_expected(data));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Single Data Bit (LSB)", test_num);
        data = 16'h0001;
        #10;
        #1;

        check_outputs(calculate_expected(data));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Single Data Bit (Mid-range)", test_num);
        data = 16'h0400;
        #10;
        #1;

        check_outputs(calculate_expected(data));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Full 15-bit Data Range", test_num);
        data = 16'h7FFF;
        #10;
        #1;

        check_outputs(calculate_expected(data));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Alternating Bits (Pattern A)", test_num);
        data = 16'h5555;
        #10;
        #1;

        check_outputs(calculate_expected(data));
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Alternating Bits (Pattern B)", test_num);
        data = 16'h2AAA;
        #10;
        #1;

        check_outputs(calculate_expected(data));
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Walking Bit Test", test_num);
        data = 16'h0010;
        #10;
        #1;

        check_outputs(calculate_expected(data));
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [19:0] expected_encoded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: encoded=%h",
                         encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded=%h",
                         expected_encoded);
                $display("  Got:      encoded=%h",
                         encoded);
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
