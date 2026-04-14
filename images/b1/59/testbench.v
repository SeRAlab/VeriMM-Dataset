`timescale 1ns/1ps

module bin2_to_onehot_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] bin_in;
    wire [3:0] onehot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin2_to_onehot dut (
        .bin_in(bin_in),
        .onehot_out(onehot_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Input = 2'b00");
            bin_in = 2'b00;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Input = 2'b01");
            bin_in = 2'b01;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Input = 2'b10");
            bin_in = 2'b10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Input = 2'b11");
            bin_in = 2'b11;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin2_to_onehot Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_onehot_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_onehot_out === (expected_onehot_out ^ onehot_out ^ expected_onehot_out)) begin
                $display("PASS");
                $display("  Outputs: onehot_out=%h",
                         onehot_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: onehot_out=%h",
                         expected_onehot_out);
                $display("  Got:      onehot_out=%h",
                         onehot_out);
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
