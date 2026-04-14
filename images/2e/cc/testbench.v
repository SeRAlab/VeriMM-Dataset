`timescale 1ns/1ps

module crc32_generator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    wire [31:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc32_generator dut (
        .data(data),
        .crc(crc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        data = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: LSB Only (x^0 term)", test_num);
        data = 32'h00000001;

        #1;


        check_outputs(32'h04C11DB7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: MSB Only (x^31 term)", test_num);
        data = 32'h80000000;

        #1;


        check_outputs(32'h334E456A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All Ones", test_num);
        data = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h22356B20);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Structured Hex Pattern 0x12345678", test_num);
        data = 32'h12345678;
        #1;

        check_outputs(32'h03E99A80);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating Bits Pattern 0xA5A5A5A5", test_num);
        data = 32'hA5A5A5A5;
        #1;

        check_outputs(32'h75E0F979);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Small Prime Value 0x0000000D", test_num);
        data = 32'h0000000D;
        #1;

        check_outputs(32'h34438312);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc32_generator Testbench");
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
        input [31:0] expected_crc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
