`timescale 1ns/1ps

module bin2bcd_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] BIN;
    wire [3:0] BCD_TENS;
    wire [3:0] BCD_UNITS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin2bcd dut (
        .BIN(BIN),
        .BCD_TENS(BCD_TENS),
        .BCD_UNITS(BCD_UNITS)
    );
    task testcase001;

        begin
            test_num = 1;
            BIN = 8'd0;
            $display("\nTest %0d: Input BIN = %d (Zero Check)", test_num, BIN);
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            BIN = 8'd9;
            $display("\nTest %0d: Input BIN = %d (Single Digit)", test_num, BIN);
            #1;

            check_outputs(4'h0, 4'h9);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            BIN = 8'd10;
            $display("\nTest %0d: Input BIN = %d (Tens boundary)", test_num, BIN);
            #1;

            check_outputs(4'h1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            BIN = 8'd42;
            $display("\nTest %0d: Input BIN = %d (Random 2-digit)", test_num, BIN);
            #1;

            check_outputs(4'h4, 4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            BIN = 8'd99;
            $display("\nTest %0d: Input BIN = %d (Max 2-digit)", test_num, BIN);
            #1;

            check_outputs(4'h9, 4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            BIN = 8'd100;
            $display("\nTest %0d: Input BIN = %d (Hundreds Boundary - Truncation Check)", test_num, BIN);

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            BIN = 8'd157;
            $display("\nTest %0d: Input BIN = %d (3-digit input, checking Tens/Units)", test_num, BIN);
            #1;

            check_outputs(4'h5, 4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            BIN = 8'd255;
            $display("\nTest %0d: Input BIN = %d (Max 8-bit input)", test_num, BIN);

            #1;


            check_outputs(4'h5, 4'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin2bcd Testbench");
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
        input [3:0] expected_BCD_TENS;
        input [3:0] expected_BCD_UNITS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BCD_TENS === (expected_BCD_TENS ^ BCD_TENS ^ expected_BCD_TENS) &&
                expected_BCD_UNITS === (expected_BCD_UNITS ^ BCD_UNITS ^ expected_BCD_UNITS)) begin
                $display("PASS");
                $display("  Outputs: BCD_TENS=%h, BCD_UNITS=%h",
                         BCD_TENS, BCD_UNITS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD_TENS=%h, BCD_UNITS=%h",
                         expected_BCD_TENS, expected_BCD_UNITS);
                $display("  Got:      BCD_TENS=%h, BCD_UNITS=%h",
                         BCD_TENS, BCD_UNITS);
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
