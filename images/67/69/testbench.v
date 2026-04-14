`timescale 1ns/1ps

module bitwise_compare_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] value;
    wire [22:0] out_and;
    wire [22:0] out_or;
    wire [23:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_compare dut (
        .value(value),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = test_num + 1;
            value = 24'h000000;
            #1;

            check_outputs(23'h000000, 23'h000000, 24'h000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones");
            test_num = test_num + 1;
            value = 24'hFFFFFF;



            #1;




            check_outputs(23'h7FFFFF, 23'h7FFFFF, 24'h000000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating pattern 0101");
            test_num = test_num + 1;
            value = 24'h555555;



            #1;




            check_outputs(23'h000000, 23'h7FFFFF, 24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating pattern 1010");
            test_num = test_num + 1;
            value = 24'hAAAAAA;



            #1;




            check_outputs(23'h000000, 23'h7FFFFF, 24'hFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single LSB set");
            test_num = test_num + 1;
            value = 24'h000001;



            #1;




            check_outputs(23'h000000, 23'h000001, 24'h800001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Single MSB set");
            test_num = test_num + 1;
            value = 24'h800000;



            #1;




            check_outputs(23'h000000, 23'h400000, 24'hC00000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Middle bit set");
            test_num = test_num + 1;
            value = 24'h000800;



            #1;




            check_outputs(23'h000000, 23'h000C00, 24'h000C00);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Two adjacent bits set");
            test_num = test_num + 1;
            value = 24'h000003;



            #1;




            check_outputs(23'h000001, 23'h000003, 24'h800002);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Mixed ends");
            test_num = test_num + 1;
            value = 24'hC00003;



            #1;




            check_outputs(23'h400001, 23'h600003, 24'h200002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_compare Testbench");
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
        input [22:0] expected_out_and;
        input [22:0] expected_out_or;
        input [23:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h, out_xor=%h",
                         out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h, out_xor=%h",
                         expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      out_and=%h, out_or=%h, out_xor=%h",
                         out_and, out_or, out_xor);
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
