`timescale 1ns/1ps

module even_parity_generator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire parity_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    even_parity_generator dut (
        .data_in(data_in),
        .parity_out(parity_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: All zeros (Count = 0, Even)", test_num);
        data_in = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Single bit set (Count = 1, Odd)", test_num);
        data_in = 4'b0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Two bits set (Count = 2, Even)", test_num);
        data_in = 4'b0011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Two bits set - alternating (Count = 2, Even)", test_num);
        data_in = 4'b1010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Three bits set (Count = 3, Odd)", test_num);
        data_in = 4'b0111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: All bits set (Count = 4, Even)", test_num);
        data_in = 4'b1111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Single bit set - MSB (Count = 1, Odd)", test_num);
        data_in = 4'b1000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Three bits set - mixed (Count = 3, Odd)", test_num);
        data_in = 4'b1101;
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
        $display("even_parity_generator Testbench");
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
        input expected_parity_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity_out === (expected_parity_out ^ parity_out ^ expected_parity_out)) begin
                $display("PASS");
                $display("  Outputs: parity_out=%b",
                         parity_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity_out=%b",
                         expected_parity_out);
                $display("  Got:      parity_out=%b",
                         parity_out);
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
