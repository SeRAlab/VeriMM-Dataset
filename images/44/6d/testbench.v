`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [6:0] seg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .seg_out(seg_out)
    );
    task testcase000;

    begin
        data_in = 4'h0;
        #10;
        $display("Testcase 0: Input 0 (0000)");
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase001;

    begin
        data_in = 4'h1;
        #10;
        $display("Testcase 1: Input 1 (0001)");
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase002;

    begin
        data_in = 4'h2;
        #10;
        $display("Testcase 2: Input 2 (0010)");
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase003;

    begin
        data_in = 4'h3;
        #10;
        $display("Testcase 3: Input 3 (0011)");
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase004;

    begin
        data_in = 4'h4;
        #10;
        $display("Testcase 4: Input 4 (0100)");
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase005;

    begin
        data_in = 4'h5;
        #10;
        $display("Testcase 5: Input 5 (0101)");
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase006;

    begin
        data_in = 4'h6;
        #10;
        $display("Testcase 6: Input 6 (0110)");
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase007;

    begin
        data_in = 4'h7;
        #10;
        $display("Testcase 7: Input 7 (0111)");
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase008;

    begin
        data_in = 4'h8;
        #10;
        $display("Testcase 8: Input 8 (1000)");
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase009;

    begin
        data_in = 4'h9;
        #10;
        $display("Testcase 9: Input 9 (1001)");
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase010;

    begin
        data_in = 4'hA;
        #10;
        $display("Testcase 10: Input A (1010)");
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase011;

    begin
        data_in = 4'hB;
        #10;
        $display("Testcase 11: Input B (1011)");
        #1;

        check_outputs(7'h7c);
    end
        endtask

    task testcase012;

    begin
        data_in = 4'hC;
        #10;
        $display("Testcase 12: Input C (1100)");
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase013;

    begin
        data_in = 4'hD;
        #10;
        $display("Testcase 13: Input D (1101)");
        #1;

        check_outputs(7'h5e);
    end
        endtask

    task testcase014;

    begin
        data_in = 4'hE;
        #10;
        $display("Testcase 14: Input E (1110)");
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase015;

    begin
        data_in = 4'hF;
        #10;
        $display("Testcase 15: Input F (1111)");
        #1;

        check_outputs(7'h71);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase000();
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
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [6:0] expected_seg_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_out === (expected_seg_out ^ seg_out ^ expected_seg_out)) begin
                $display("PASS");
                $display("  Outputs: seg_out=%h",
                         seg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_out=%h",
                         expected_seg_out);
                $display("  Got:      seg_out=%h",
                         seg_out);
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
