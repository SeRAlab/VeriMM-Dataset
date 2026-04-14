`timescale 1ns/1ps

module mux_16_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [3:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16_to_1 dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Select index 0, check bit 0 is HIGH");
        in = 16'h0001;
        sel = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Select index 0, check bit 0 is LOW with other bits HIGH");
        in = 16'hFFFE;
        sel = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Select index 15, check bit 15 is HIGH");
        in = 16'h8000;
        sel = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Select index 15, check bit 15 is LOW with other bits HIGH");
        in = 16'h7FFF;
        sel = 4'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Select index 7, check bit 7 is HIGH");
        in = 16'h0080;
        sel = 4'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Select index 8, check bit 8 is LOW");
        in = 16'hFEFF;
        sel = 4'd8;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Select index 3, verify input patterns do not affect output (Alternating bits)");
        in = 16'hAAAA;
        sel = 4'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Select index 4, verify input patterns do not affect output (Alternating bits)");
        in = 16'hAAAA;
        sel = 4'd4;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: All inputs HIGH");
        in = 16'hFFFF;
        sel = 4'd11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: All inputs LOW");
        in = 16'h0000;
        sel = 4'd5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase 011: Middle select 10, target bit HIGH");
        in = 16'h0400;
        sel = 4'd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase 012: Random index 1, check target bit LOW");
        in = 16'hFFFD;
        sel = 4'd1;
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
        $display("mux_16_to_1 Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
