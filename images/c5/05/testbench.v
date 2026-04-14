`timescale 1ns/1ps

module signal_converter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    signal_converter dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        $display("Testcase 001: Input = 0 (Condition: < 5)");
        in = 4'd0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Input = 4 (Condition: < 5)");
        in = 4'd4;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Input = 5 (Condition: 5 <= in <= 9)");
        in = 4'd5;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Input = 7 (Condition: 5 <= in <= 9)");
        in = 4'd7;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Input = 9 (Condition: 5 <= in <= 9)");
        in = 4'd9;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Input = 10 (Condition: > 9)");
        in = 4'd10;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Input = 15 (Condition: > 9)");
        in = 4'd15;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Input = 2 (Condition: < 5)");
        in = 4'd2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Input = 12 (Condition: > 9)");
        in = 4'd12;
        #1;

        check_outputs(2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("signal_converter Testbench");
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
        input [1:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
