`timescale 1ns/1ps

module alu_bit_select_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] bsel;
    wire [3:0] bs_out_high;
    wire [3:0] bs_out_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_bit_select dut (
        .bsel(bsel),
        .bs_out_high(bs_out_high),
        .bs_out_low(bs_out_low)
    );
    task testcase001;

    begin
        $display("Test Case 001: bsel = 3'b000 (Low Bank, Bit 0)");
        bsel = 3'b000;
        #1;

        check_outputs(4'h0, 4'h1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: bsel = 3'b001 (Low Bank, Bit 1)");
        bsel = 3'b001;
        #1;

        check_outputs(4'h0, 4'h2);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: bsel = 3'b010 (Low Bank, Bit 2)");
        bsel = 3'b010;
        #1;

        check_outputs(4'h0, 4'h4);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: bsel = 3'b011 (Low Bank, Bit 3)");
        bsel = 3'b011;
        #1;

        check_outputs(4'h0, 4'h8);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: bsel = 3'b100 (High Bank, Bit 0)");
        bsel = 3'b100;
        #1;

        check_outputs(4'h1, 4'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: bsel = 3'b101 (High Bank, Bit 1)");
        bsel = 3'b101;
        #1;

        check_outputs(4'h2, 4'h0);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: bsel = 3'b110 (High Bank, Bit 2)");
        bsel = 3'b110;
        #1;

        check_outputs(4'h4, 4'h0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: bsel = 3'b111 (High Bank, Bit 3)");
        bsel = 3'b111;
        #1;

        check_outputs(4'h8, 4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_bit_select Testbench");
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
        input [3:0] expected_bs_out_high;
        input [3:0] expected_bs_out_low;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bs_out_high === (expected_bs_out_high ^ bs_out_high ^ expected_bs_out_high) &&
                expected_bs_out_low === (expected_bs_out_low ^ bs_out_low ^ expected_bs_out_low)) begin
                $display("PASS");
                $display("  Outputs: bs_out_high=%h, bs_out_low=%h",
                         bs_out_high, bs_out_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bs_out_high=%h, bs_out_low=%h",
                         expected_bs_out_high, expected_bs_out_low);
                $display("  Got:      bs_out_high=%h, bs_out_low=%h",
                         bs_out_high, bs_out_low);
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
