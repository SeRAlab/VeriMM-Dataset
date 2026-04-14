`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    reg en;
    wire [15:0] dec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .bin(bin),
        .en(en),
        .dec(dec)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Testing Disabled state (en=0)", test_num);
        en = 1'b0;
        bin = 4'hA;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Testing bin=4'h0 (en=1)", test_num);
        en = 1'b1;
        bin = 4'h0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Testing bin=4'h7 (en=1)", test_num);
        en = 1'b1;
        bin = 4'h7;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Testing bin=4'hF (en=1)", test_num);
        en = 1'b1;
        bin = 4'hF;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Testing bin=4'hA (en=1)", test_num);
        en = 1'b1;
        bin = 4'hA;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Testing Enable transition to 0", test_num);
        bin = 4'h3;
        en = 1'b1;
        #5;
        en = 1'b0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = 7;
        $display("Testcase %03d: Comprehensive sweep of all 16 inputs", test_num);
        en = 1'b1;
        for (i = 0; i < 16; i = i + 1) begin
            bin = i;
            #1;
            if (dec !== (16'b1 << i)) begin
                $display("  FAILED at bin=%0d", i);
            end
        end

        bin = 4'd15;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_dec;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dec === (expected_dec ^ dec ^ expected_dec)) begin
                $display("PASS");
                $display("  Outputs: dec=%h",
                         dec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec=%h",
                         expected_dec);
                $display("  Got:      dec=%h",
                         dec);
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
