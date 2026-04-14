`timescale 1ns/1ps

module binary_to_bcd_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    wire [4:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_bcd_4bit dut (
        .binary_in(binary_in),
        .bcd_out(bcd_out)
    );
    task testcase001;

    begin
        test_num = 1;
        binary_in = 4'd0;
        $display("Test Case %0d: Input = %d (Minimum Value)", test_num, binary_in);
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        binary_in = 4'd5;
        $display("Test Case %0d: Input = %d (Single Digit)", test_num, binary_in);
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        binary_in = 4'd9;
        $display("Test Case %0d: Input = %d (Maximum Single Digit)", test_num, binary_in);
        #1;

        check_outputs(5'h09);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        binary_in = 4'd10;
        $display("Test Case %0d: Input = %d (Transition to Tens Place)", test_num, binary_in);
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        binary_in = 4'd13;
        $display("Test Case %0d: Input = %d (Mid-range Two Digits)", test_num, binary_in);
        #1;

        check_outputs(5'h13);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        binary_in = 4'd15;
        $display("Test Case %0d: Input = %d (Maximum 4-bit Value)", test_num, binary_in);
        #1;

        check_outputs(5'h15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_bcd_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_bcd_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h",
                         bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h",
                         expected_bcd_out);
                $display("  Got:      bcd_out=%h",
                         bcd_out);
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
