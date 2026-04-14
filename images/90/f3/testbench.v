`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] address;
    reg [31:0] length;
    reg [2:0] maximum_burst_count;
    reg short_first_access_enable;
    reg short_first_and_last_access_enable;
    reg short_last_access_enable;
    wire [2:0] burst_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .length(length),
        .maximum_burst_count(maximum_burst_count),
        .short_first_access_enable(short_first_access_enable),
        .short_first_and_last_access_enable(short_first_and_last_access_enable),
        .short_last_access_enable(short_last_access_enable),
        .burst_count(burst_count)
    );
    task testcase001;

        begin
            test_num = 1;
            address = 32'h0000_0000;
            length = 32'h0000_0010;
            maximum_burst_count = 3'd4;
            short_first_access_enable = 1'b0;
            short_last_access_enable = 1'b0;
            short_first_and_last_access_enable = 1'b0;
            $display("Testcase %0d: Aligned access, flags disabled", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            address = 32'h0000_0000;
            length = 32'h0000_0002;
            maximum_burst_count = 3'd4;
            short_first_access_enable = 1'b0;
            short_last_access_enable = 1'b1;
            short_first_and_last_access_enable = 1'b0;
            $display("Testcase %0d: Short last access enabled, length < max", test_num);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            address = 32'h0000_0001;
            length = 32'h0000_0010;
            maximum_burst_count = 3'd4;
            short_first_access_enable = 1'b1;
            short_last_access_enable = 1'b0;
            short_first_and_last_access_enable = 1'b0;
            $display("Testcase %0d: Short first access enabled, address misaligned (offset 1)", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            address = 32'h0000_0001;
            length = 32'h0000_0002;
            maximum_burst_count = 3'd4;
            short_first_access_enable = 1'b0;
            short_last_access_enable = 1'b0;
            short_first_and_last_access_enable = 1'b1;
            $display("Testcase %0d: Short first and last enabled, length 2", test_num);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            address = 32'h0000_0000;
            length = 32'h0000_0020;
            maximum_burst_count = 3'd7;
            short_first_access_enable = 1'b0;
            short_last_access_enable = 1'b0;
            short_first_and_last_access_enable = 1'b0;
            $display("Testcase %0d: Maximum burst count boundary (7)", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            address = 32'h0000_0003;
            length = 32'h0000_0010;
            maximum_burst_count = 3'd4;
            short_first_access_enable = 1'b1;
            short_last_access_enable = 1'b0;
            short_first_and_last_access_enable = 1'b0;
            $display("Testcase %0d: Short first access, address misaligned (offset 3)", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            address = 32'h0000_0000;
            length = 32'h0000_0001;
            maximum_burst_count = 3'd4;
            short_first_access_enable = 1'b0;
            short_last_access_enable = 1'b0;
            short_first_and_last_access_enable = 1'b0;
            $display("Testcase %0d: Length 1 but short flags disabled", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            address = 32'h0000_0000;
            length = 32'h0000_0010;
            maximum_burst_count = 3'd4;
            short_first_access_enable = 1'b1;
            short_last_access_enable = 1'b1;
            short_first_and_last_access_enable = 1'b1;
            $display("Testcase %0d: All flags enabled, length > max, aligned", test_num);
            #1;

            check_outputs(3'd4);
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
        input [2:0] expected_burst_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_burst_count === (expected_burst_count ^ burst_count ^ expected_burst_count)) begin
                $display("PASS");
                $display("  Outputs: burst_count=%h",
                         burst_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: burst_count=%h",
                         expected_burst_count);
                $display("  Got:      burst_count=%h",
                         burst_count);
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
