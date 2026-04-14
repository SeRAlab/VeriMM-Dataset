`timescale 1ns/1ps

module odd_parity_checker_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    wire parity_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    odd_parity_checker dut (
        .data_in(data_in),
        .parity_out(parity_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 5'b00000;
        $display("Testcase %0d: Input 00000 (Even number of 1s: 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 5'b00001;
        $display("Testcase %0d: Input 00001 (Odd number of 1s: 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 5'b00011;
        $display("Testcase %0d: Input 00011 (Even number of 1s: 2)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 5'b00111;
        $display("Testcase %0d: Input 00111 (Odd number of 1s: 3)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 5'b01111;
        $display("Testcase %0d: Input 01111 (Even number of 1s: 4)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 5'b11111;
        $display("Testcase %0d: Input 11111 (Odd number of 1s: 5)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 5'b10101;
        $display("Testcase %0d: Input 10101 (Odd number of 1s: 3)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 5'b11000;
        $display("Testcase %0d: Input 11000 (Even number of 1s: 2)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 5'b10000;
        $display("Testcase %0d: Input 10000 (Odd number of 1s: 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 5'b01010;
        $display("Testcase %0d: Input 01010 (Even number of 1s: 2)", test_num);
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
        $display("odd_parity_checker Testbench");
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
