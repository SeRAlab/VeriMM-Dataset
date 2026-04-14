`timescale 1ns/1ps

module decoder_3to8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg en;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_3to8 dut (
        .a(a),
        .en(en),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Disabled state (en=0, a=0)");
        en = 0;
        a = 3'b000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Disabled state (en=0, a=7)");
        en = 0;
        a = 3'b111;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Enabled, a=0");
        en = 1;
        a = 3'b000;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Enabled, a=1");
        en = 1;
        a = 3'b001;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Enabled, a=2");
        en = 1;
        a = 3'b010;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Enabled, a=3");
        en = 1;
        a = 3'b011;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Enabled, a=4");
        en = 1;
        a = 3'b100;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Enabled, a=5");
        en = 1;
        a = 3'b101;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Enabled, a=6");
        en = 1;
        a = 3'b110;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Enabled, a=7");
        en = 1;
        a = 3'b111;
        #1;

        check_outputs(8'h80);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_3to8 Testbench");
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
