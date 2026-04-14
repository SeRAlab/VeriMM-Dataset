`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    wire checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .data(data),
        .checksum(checksum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input all zeros", test_num);
        data = 8'b00000000;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input all ones", test_num);
        data = 8'b11111111;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit set", test_num);
        data = 8'b00000001;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two bits set", test_num);
        data = 8'b10100000;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (even parity)", test_num);
        data = 8'b10101010;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Seven bits set", test_num);
        data = 8'b11111110;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random pattern 1", test_num);
        data = 8'b01100110;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random pattern 2", test_num);
        data = 8'b10011010;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern with 3 bits", test_num);
        data = 8'b00111000;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High nibble set", test_num);
        data = 8'b11110000;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
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
        input expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%b",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%b",
                         expected_checksum);
                $display("  Got:      checksum=%b",
                         checksum);
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
