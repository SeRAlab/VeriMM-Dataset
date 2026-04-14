`timescale 1ns/1ps

module checksum_generator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg reset;
    wire [3:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_generator dut (
        .data(data),
        .reset(reset),
        .checksum(checksum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset functionality");
        reset = 1;
        data = 4'b1011;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All zeros input");
        reset = 1; #5; reset = 0;
        data = 4'b0000;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Single bit set (0001)");
        reset = 1; #5; reset = 0;
        data = 4'b0001;
        #10;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Two bits set (0011)");
        reset = 1; #5; reset = 0;
        data = 4'b0011;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Three bits set (0111)");
        reset = 1; #5; reset = 0;
        data = 4'b0111;
        #10;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: All ones input (1111)");
        reset = 1; #5; reset = 0;
        data = 4'b1111;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Alternating bits (1010)");
        reset = 1; #5; reset = 0;
        data = 4'b1010;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Complex pattern (1101)");
        reset = 1; #5; reset = 0;
        data = 4'b1101;
        #10;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_generator Testbench");
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
        input [3:0] expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
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
