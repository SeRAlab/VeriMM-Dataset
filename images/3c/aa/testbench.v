`timescale 1ns/1ps

module bluetooth_strength_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] strength_in;
    wire [1:0] strength_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_strength dut (
        .strength_in(strength_in),
        .strength_out(strength_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input = 0 (Range: < 5, Expected: 00)", test_num);
        strength_in = 5'd0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input = 4 (Range: < 5, Expected: 00)", test_num);
        strength_in = 5'd4;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input = 5 (Range: 5-10, Expected: 01)", test_num);
        strength_in = 5'd5;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input = 10 (Range: 5-10, Expected: 01)", test_num);
        strength_in = 5'd10;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input = 11 (Range: 11-15, Expected: 10)", test_num);
        strength_in = 5'd11;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input = 15 (Range: 11-15, Expected: 10)", test_num);
        strength_in = 5'd15;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input = 16 (Range: > 15, Expected: 11)", test_num);
        strength_in = 5'd16;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input = 31 (Range: > 15, Expected: 11)", test_num);
        strength_in = 5'd31;
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
        $display("bluetooth_strength Testbench");
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
        input [1:0] expected_strength_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strength_out === (expected_strength_out ^ strength_out ^ expected_strength_out)) begin
                $display("PASS");
                $display("  Outputs: strength_out=%h",
                         strength_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strength_out=%h",
                         expected_strength_out);
                $display("  Got:      strength_out=%h",
                         strength_out);
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
