`timescale 1ns/1ps

module bin_to_7seg_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] BIN;
    wire [6:0] SEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_7seg dut (
        .BIN(BIN),
        .SEG(SEG)
    );
    task testcase001;

    begin
        test_num = 1;
        BIN = 3'b000;
        $display("Test %0d: Input BIN = 3'b000 (Digit 0)", test_num);

        #1;


        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        BIN = 3'b001;
        $display("Test %0d: Input BIN = 3'b001 (Digit 1)", test_num);

        #1;


        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        BIN = 3'b010;
        $display("Test %0d: Input BIN = 3'b010 (Digit 2)", test_num);

        #1;


        check_outputs(7'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        BIN = 3'b011;
        $display("Test %0d: Input BIN = 3'b011 (Digit 3)", test_num);

        #1;


        check_outputs(7'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        BIN = 3'b100;
        $display("Test %0d: Input BIN = 3'b100 (Digit 4)", test_num);

        #1;


        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        BIN = 3'b101;
        $display("Test %0d: Input BIN = 3'b101 (Digit 5)", test_num);

        #1;


        check_outputs(7'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        BIN = 3'b110;
        $display("Test %0d: Input BIN = 3'b110 (Digit 6)", test_num);

        #1;


        check_outputs(7'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        BIN = 3'b111;
        $display("Test %0d: Input BIN = 3'b111 (Digit 7)", test_num);

        #1;


        check_outputs(7'h07);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_7seg Testbench");
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
        input [6:0] expected_SEG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SEG === (expected_SEG ^ SEG ^ expected_SEG)) begin
                $display("PASS");
                $display("  Outputs: SEG=%h",
                         SEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SEG=%h",
                         expected_SEG);
                $display("  Got:      SEG=%h",
                         SEG);
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
