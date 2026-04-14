`timescale 1ns/1ps

module checksum_generator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_generator dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 4'b0000;
            $display("Testcase %0d: data_in = %b (0 ones - Even)", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 4'b0001;
            $display("Testcase %0d: data_in = %b (1 one - Odd)", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 4'b0011;
            $display("Testcase %0d: data_in = %b (2 ones - Even)", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 4'b0111;
            $display("Testcase %0d: data_in = %b (3 ones - Odd)", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 4'b1111;
            $display("Testcase %0d: data_in = %b (4 ones - Even)", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 4'b1010;
            $display("Testcase %0d: data_in = %b (2 ones - Even)", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 4'b1000;
            $display("Testcase %0d: data_in = %b (1 one - Odd)", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 4'b0101;
            $display("Testcase %0d: data_in = %b (2 ones - Even)", test_num, data_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 4'b1011;
            $display("Testcase %0d: data_in = %b (3 ones - Odd)", test_num, data_in);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 4'b0110;
            $display("Testcase %0d: data_in = %b (2 ones - Even)", test_num, data_in);
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
        input expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%b",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%b",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%b",
                         checksum_out);
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
