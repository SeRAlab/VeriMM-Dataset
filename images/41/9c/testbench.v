`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] value;
    wire [19:0] note_div;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .value(value),
        .note_div(note_div)
    );
    task testcase000;

    begin
        test_num = test_num + 1;
        value = 4'd0;
        #10;
        $display("Testcase %0d: Input value = 0 (C4)", test_num);
        #1;

        check_outputs(20'd191113);
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        value = 4'd1;
        #10;
        $display("Testcase %0d: Input value = 1 (C#4)", test_num);
        #1;

        check_outputs(20'd180388);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        value = 4'd2;
        #10;
        $display("Testcase %0d: Input value = 2 (D4)", test_num);
        #1;

        check_outputs(20'd170262);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        value = 4'd3;
        #10;
        $display("Testcase %0d: Input value = 3 (D#4)", test_num);
        #1;

        check_outputs(20'd160707);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        value = 4'd4;
        #10;
        $display("Testcase %0d: Input value = 4 (E4)", test_num);
        #1;

        check_outputs(20'd151685);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        value = 4'd5;
        #10;
        $display("Testcase %0d: Input value = 5 (F4)", test_num);
        #1;

        check_outputs(20'd143172);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        value = 4'd6;
        #10;
        $display("Testcase %0d: Input value = 6 (F#4)", test_num);
        #1;

        check_outputs(20'd135144);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        value = 4'd7;
        #10;
        $display("Testcase %0d: Input value = 7 (G4)", test_num);
        #1;

        check_outputs(20'd127553);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        value = 4'd8;
        #10;
        $display("Testcase %0d: Input value = 8 (G#4)", test_num);
        #1;

        check_outputs(20'd120393);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        value = 4'd9;
        #10;
        $display("Testcase %0d: Input value = 9 (A4)", test_num);
        #1;

        check_outputs(20'd113636);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        value = 4'd10;
        #10;
        $display("Testcase %0d: Input value = 10 (A#4)", test_num);
        #1;

        check_outputs(20'd107258);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        value = 4'd11;
        #10;
        $display("Testcase %0d: Input value = 11 (B4)", test_num);
        #1;

        check_outputs(20'd101238);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        value = 4'd12;
        #10;
        $display("Testcase %0d: Input value = 12 (C5)", test_num);
        #1;

        check_outputs(20'd95556);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        value = 4'd13;
        #10;
        $display("Testcase %0d: Input value = 13 (C#5)", test_num);
        #1;

        check_outputs(20'd90194);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        value = 4'd14;
        #10;
        $display("Testcase %0d: Input value = 14 (D5)", test_num);
        #1;

        check_outputs(20'd85131);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        value = 4'd15;
        #10;
        $display("Testcase %0d: Input value = 15 (D#5)", test_num);
        #1;

        check_outputs(20'd80353);
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
        input [19:0] expected_note_div;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_note_div === (expected_note_div ^ note_div ^ expected_note_div)) begin
                $display("PASS");
                $display("  Outputs: note_div=%h",
                         note_div);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: note_div=%h",
                         expected_note_div);
                $display("  Got:      note_div=%h",
                         note_div);
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
