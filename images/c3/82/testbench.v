`timescale 1ns/1ps

module binary_converter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    wire [1:0] binary_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_converter dut (
        .binary_in(binary_in),
        .binary_out(binary_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input = 0 (Smallest value, even, < 5)", test_num);
            binary_in = 4'd0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input = 1 (Odd, < 5)", test_num);
            binary_in = 4'd1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input = 4 (Boundary: strictly less than 5, even)", test_num);
            binary_in = 4'd4;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input = 5 (Boundary: equal to 5, odd)", test_num);
            binary_in = 4'd5;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input = 6 (Greater than 5, even)", test_num);
            binary_in = 4'd6;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input = 10 (Large value, even)", test_num);
            binary_in = 4'd10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input = 15 (Max value, odd)", test_num);
            binary_in = 4'd15;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_converter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_binary_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h",
                         binary_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h",
                         expected_binary_out);
                $display("  Got:      binary_out=%h",
                         binary_out);
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
