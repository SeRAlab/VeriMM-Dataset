`timescale 1ns/1ps

module binary_to_decimal_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] binary;
    wire [3:0] decimal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_decimal dut (
        .binary(binary),
        .decimal(decimal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 000", test_num);
            binary = 3'b000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 001", test_num);
            binary = 3'b001;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 010", test_num);
            binary = 3'b010;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 011", test_num);
            binary = 3'b011;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 100", test_num);
            binary = 3'b100;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 101", test_num);
            binary = 3'b101;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 110", test_num);
            binary = 3'b110;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 111", test_num);
            binary = 3'b111;
            #1;

            check_outputs(4'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_decimal Testbench");
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
        input [3:0] expected_decimal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal === (expected_decimal ^ decimal ^ expected_decimal)) begin
                $display("PASS");
                $display("  Outputs: decimal=%h",
                         decimal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal=%h",
                         expected_decimal);
                $display("  Got:      decimal=%h",
                         decimal);
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
