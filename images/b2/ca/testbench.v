`timescale 1ns/1ps

module even_parity_gen_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] data;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    even_parity_gen dut (
        .data(data),
        .parity(parity)
    );
    task testcase001;

        begin
            $display("Test Case 001: All zeros");
            data = 6'b000000;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All ones");
            data = 6'b111111;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Single bit set (LSB)");
            data = 6'b000001;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Single bit set (MSB)");
            data = 6'b100000;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Three bits set (odd)");
            data = 6'b101010;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Two bits set (even)");
            data = 6'b110000;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Four bits set (even)");
            data = 6'b110011;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Five bits set (odd)");
            data = 6'b011111;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Alternating bits (010101)");
            data = 6'b010101;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Symmetric bits (100001)");
            data = 6'b100001;

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
        $display("even_parity_gen Testbench");
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
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%b",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b",
                         expected_parity);
                $display("  Got:      parity=%b",
                         parity);
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
