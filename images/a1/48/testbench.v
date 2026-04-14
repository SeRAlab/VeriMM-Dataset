`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] channel;
    reg en1;
    reg en10;
    reg en11;
    reg en12;
    reg en13;
    reg en14;
    reg en15;
    reg en16;
    reg en17;
    reg en18;
    reg en19;
    reg en2;
    reg en3;
    reg en4;
    reg en5;
    reg en6;
    reg en7;
    reg en8;
    reg en9;
    wire en_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channel(channel),
        .en1(en1),
        .en10(en10),
        .en11(en11),
        .en12(en12),
        .en13(en13),
        .en14(en14),
        .en15(en15),
        .en16(en16),
        .en17(en17),
        .en18(en18),
        .en19(en19),
        .en2(en2),
        .en3(en3),
        .en4(en4),
        .en5(en5),
        .en6(en6),
        .en7(en7),
        .en8(en8),
        .en9(en9),
        .en_out(en_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select en1 (channel 0) - High", test_num);
        channel = 8'd0;
        en1 = 1; en2 = 0; en3 = 0; en4 = 0; en5 = 0;
        en6 = 0; en7 = 0; en8 = 0; en9 = 0; en10 = 0;
        en11 = 0; en12 = 0; en13 = 0; en14 = 0; en15 = 0;
        en16 = 0; en17 = 0; en18 = 0; en19 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select en1 (channel 0) - Low", test_num);
        channel = 8'd0;
        en1 = 0; en2 = 1; en3 = 1; en4 = 1; en5 = 1;
        en6 = 1; en7 = 1; en8 = 1; en9 = 1; en10 = 1;
        en11 = 1; en12 = 1; en13 = 1; en14 = 1; en15 = 1;
        en16 = 1; en17 = 1; en18 = 1; en19 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select en2 (channel 1) - High", test_num);
        channel = 8'd1;
        en1 = 0; en2 = 1; en3 = 0; en4 = 0; en5 = 0;
        en6 = 0; en7 = 0; en8 = 0; en9 = 0; en10 = 0;
        en11 = 0; en12 = 0; en13 = 0; en14 = 0; en15 = 0;
        en16 = 0; en17 = 0; en18 = 0; en19 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select en10 (channel 9) - High", test_num);
        channel = 8'd9;
        en1 = 0; en2 = 0; en3 = 0; en4 = 0; en5 = 0;
        en6 = 0; en7 = 0; en8 = 0; en9 = 0; en10 = 1;
        en11 = 0; en12 = 0; en13 = 0; en14 = 0; en15 = 0;
        en16 = 0; en17 = 0; en18 = 0; en19 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select en19 (channel 18) - High", test_num);
        channel = 8'd18;
        en1 = 0; en2 = 0; en3 = 0; en4 = 0; en5 = 0;
        en6 = 0; en7 = 0; en8 = 0; en9 = 0; en10 = 0;
        en11 = 0; en12 = 0; en13 = 0; en14 = 0; en15 = 0;
        en16 = 0; en17 = 0; en18 = 0; en19 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - Out of range (channel 19)", test_num);
        channel = 8'd19;
        en1 = 1; en2 = 1; en3 = 1; en4 = 1; en5 = 1;
        en6 = 1; en7 = 1; en8 = 1; en9 = 1; en10 = 1;
        en11 = 1; en12 = 1; en13 = 1; en14 = 1; en15 = 1;
        en16 = 1; en17 = 1; en18 = 1; en19 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - Maximum channel value (255)", test_num);
        channel = 8'd255;
        en1 = 1; en2 = 1; en3 = 1; en4 = 1; en5 = 1;
        en6 = 1; en7 = 1; en8 = 1; en9 = 1; en10 = 1;
        en11 = 1; en12 = 1; en13 = 1; en14 = 1; en15 = 1;
        en16 = 1; en17 = 1; en18 = 1; en19 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selection interference check (channel 5, en6=1, others=0)", test_num);
        channel = 8'd5;
        en1 = 0; en2 = 0; en3 = 0; en4 = 0; en5 = 0;
        en6 = 1; en7 = 0; en8 = 0; en9 = 0; en10 = 0;
        en11 = 0; en12 = 0; en13 = 0; en14 = 0; en15 = 0;
        en16 = 0; en17 = 0; en18 = 0; en19 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selection interference check (channel 5, en6=0, others=1)", test_num);
        channel = 8'd5;
        en1 = 1; en2 = 1; en3 = 1; en4 = 1; en5 = 1;
        en6 = 0; en7 = 1; en8 = 1; en9 = 1; en10 = 1;
        en11 = 1; en12 = 1; en13 = 1; en14 = 1; en15 = 1;
        en16 = 1; en17 = 1; en18 = 1; en19 = 1;
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
        $display("top_module Testbench");
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
        input expected_en_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en_out === (expected_en_out ^ en_out ^ expected_en_out)) begin
                $display("PASS");
                $display("  Outputs: en_out=%b",
                         en_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en_out=%b",
                         expected_en_out);
                $display("  Got:      en_out=%b",
                         en_out);
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
