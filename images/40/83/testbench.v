`timescale 1ns/1ps

module tcp_checksum_validator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] checksum;
    reg [31:0] payload;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_checksum_validator dut (
        .checksum(checksum),
        .payload(payload),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros Payload", test_num);
        payload = 32'h0000_0000;
        checksum = 16'hFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simple Payload No Carry", test_num);
        payload = 32'h0001_0002;
        checksum = 16'hFFFC;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Carry Wrap Case", test_num);
        payload = 32'hFFFF_0001;
        checksum = 16'hFFFE;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum Values", test_num);
        payload = 32'hFFFF_FFFF;
        checksum = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Random Data 1", test_num);
        payload = 32'h1234_5678;
        checksum = 16'h9753;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Checksum (One bit off)", test_num);
        payload = 32'h1234_5678;
        checksum = 16'h9752;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiple Carries", test_num);
        payload = 32'h8000_8001;
        checksum = 16'hFFFD;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: ABCD Pattern", test_num);
        payload = 32'hABCD_DCBA;
        checksum = 16'h7777;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bits", test_num);
        payload = 32'hAAAA_5555;
        checksum = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Zero Checksum for Zero Payload", test_num);
        payload = 32'h0000_0000;
        checksum = 16'h0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_checksum_validator Testbench");
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: valid=%b",
                         valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b",
                         expected_valid);
                $display("  Got:      valid=%b",
                         valid);
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
