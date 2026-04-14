`timescale 1ns/1ps

module priority_encoder_4to2_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    wire [1:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4to2 dut (
        .a(a),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'b1000;
        $display("Test %0d: Input a = %b (MSB only)", test_num, a);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'b0100;
        $display("Test %0d: Input a = %b", test_num, a);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'b0010;
        $display("Test %0d: Input a = %b", test_num, a);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'b0001;
        $display("Test %0d: Input a = %b (LSB only)", test_num, a);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'b1111;
        $display("Test %0d: Input a = %b (All bits set, expect MSB priority)", test_num, a);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'b0111;
        $display("Test %0d: Input a = %b (Bits 2,1,0 set, expect bit 2)", test_num, a);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'b0011;
        $display("Test %0d: Input a = %b (Bits 1,0 set, expect bit 1)", test_num, a);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'b1010;
        $display("Test %0d: Input a = %b (Bits 3,1 set, expect bit 3)", test_num, a);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'b0101;
        $display("Test %0d: Input a = %b (Bits 2,0 set, expect bit 2)", test_num, a);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'b1001;
        $display("Test %0d: Input a = %b (Bits 3,0 set, expect bit 3)", test_num, a);
        #1;

        check_outputs(2'b11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_4to2 Testbench");
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
        input [1:0] expected_y;
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
