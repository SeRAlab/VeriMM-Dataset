`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire detect;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .detect(detect),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros - No bits set", test_num);
        in = 8'b00000000;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 0 set (LSB)", test_num);
        in = 8'b00000001;
        #1;

        check_outputs(1'b1, 3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 7 set (MSB)", test_num);
        in = 8'b10000000;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 4 set", test_num);
        in = 8'b00010000;
        #1;

        check_outputs(1'b1, 3'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple bits (7 and 0) - Priority to 7", test_num);
        in = 8'b10000001;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple bits (3, 2, 1) - Priority to 3", test_num);
        in = 8'b00001110;
        #1;

        check_outputs(1'b1, 3'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All bits set - Priority to 7", test_num);
        in = 8'b11111111;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 1 only", test_num);
        in = 8'b00000010;
        #1;

        check_outputs(1'b1, 3'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bits 6 and 5 set - Priority to 6", test_num);
        in = 8'b01100000;
        #1;

        check_outputs(1'b1, 3'd6);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits (5, 3, 1) - Priority to 5", test_num);
        in = 8'b00101010;
        #1;

        check_outputs(1'b1, 3'd5);
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
        input expected_detect;
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_detect === (expected_detect ^ detect ^ expected_detect) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: detect=%b, out=%h",
                         detect, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detect=%b, out=%h",
                         expected_detect, expected_out);
                $display("  Got:      detect=%b, out=%h",
                         detect, out);
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
