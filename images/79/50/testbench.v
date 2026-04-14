`timescale 1ns/1ps

module priority_encoder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    wire valid;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_16bit dut (
        .a(a),
        .valid(valid),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h0000;
            $display("Test %0d: All zeros input", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h0001;
            $display("Test %0d: Bit 0 set", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'h8000;
            $display("Test %0d: Bit 15 set", test_num);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'hFFFF;
            $display("Test %0d: All bits set (Priority should be 15)", test_num);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'h00FF;
            $display("Test %0d: Bits 0-7 set (Priority should be 7)", test_num);
            #1;

            check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'h0400;
            $display("Test %0d: Bit 10 only set", test_num);
            #1;

            check_outputs(1'b1, 4'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'h2011;
            $display("Test %0d: Sparse bits (13, 4, 0) set", test_num);
            #1;

            check_outputs(1'b1, 4'd13);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 16'h0002;
            $display("Test %0d: Bit 1 only set", test_num);
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 16'h4AAA;
            $display("Test %0d: Alternating bits, highest is 14", test_num);
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 16'h0010;
            $display("Test %0d: Bit 4 set", test_num);
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_16bit Testbench");
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
        input expected_valid;
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, y=%h",
                         valid, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, y=%h",
                         expected_valid, expected_y);
                $display("  Got:      valid=%b, y=%h",
                         valid, y);
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
