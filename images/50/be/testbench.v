`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] c;
    reg [7:0] data;
    wire [15:0] next_crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .data(data),
        .next_crc(next_crc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            c = 16'h0000;
            data = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: USB Init + Zero Byte", test_num);
            c = 16'hFFFF;
            data = 8'h00;
            #1;

            check_outputs(16'h40BF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero State + LSB Data Bit", test_num);
            c = 16'h0000;
            data = 8'h01;
            #1;

            check_outputs(16'hC0C1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            c = 16'hFFFF;
            data = 8'hFF;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Pattern 1", test_num);
            c = 16'h1234;
            data = 8'h56;
            #1;

            check_outputs(16'hE993);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Chained Calculation", test_num);


            c = 16'h85FE;
            data = 8'h02;
            #1;

            check_outputs(16'h4185);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            c = 16'h5555;
            data = 8'hAA;
            #1;

            check_outputs(16'h4015);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero State + MSB Data Bit", test_num);
            c = 16'h0000;
            data = 8'h80;
            #1;

            check_outputs(16'hA001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit in CRC LSB", test_num);
            c = 16'h0001;
            data = 8'h00;
            #1;

            check_outputs(16'hA001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data and CRC bit cancellation", test_num);

            c = 16'h0001;
            data = 8'h01;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_next_crc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_crc === (expected_next_crc ^ next_crc ^ expected_next_crc)) begin
                $display("PASS");
                $display("  Outputs: next_crc=%h",
                         next_crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_crc=%h",
                         expected_next_crc);
                $display("  Got:      next_crc=%h",
                         next_crc);
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
