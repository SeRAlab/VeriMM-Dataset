`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bus;
    wire line;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus(bus),
        .line(line)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 0 (all zeros)", test_num);
            bus = 8'b00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 1 (lsb set)", test_num);
            bus = 8'b00000001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 0 (other bits set)", test_num);
            bus = 8'b11111110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 1 (all ones)", test_num);
            bus = 8'b11111111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 0 (alternating bits)", test_num);
            bus = 8'b10101010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 1 (alternating bits)", test_num);
            bus = 8'b01010101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 0 (upper nibble set)", test_num);
            bus = 8'hF0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bus[0] = 1 (bit 0 only)", test_num);
            bus = 8'h01;
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
        input expected_line;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_line === (expected_line ^ line ^ expected_line)) begin
                $display("PASS");
                $display("  Outputs: line=%b",
                         line);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: line=%b",
                         expected_line);
                $display("  Got:      line=%b",
                         line);
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
