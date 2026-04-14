`timescale 1ns/1ps

module priority_encoder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [3:0] pos;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_16bit dut (
        .in(in),
        .pos(pos),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zeros input", test_num);
            in = 16'h0000;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MSB only (Bit 15)", test_num);
            in = 16'h8000;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LSB only (Bit 0)", test_num);
            in = 16'h0001;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bits high", test_num);
            in = 16'hFFFF;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 7 set with lower bits", test_num);
            in = 16'h00FF;
            #1;

            check_outputs(4'd7, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 4 only", test_num);
            in = 16'h0010;
            #1;

            check_outputs(4'd4, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 11 priority", test_num);
            in = 16'h08A2;
            #1;

            check_outputs(4'd11, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 1 only", test_num);
            in = 16'h0002;
            #1;

            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 14 set", test_num);
            in = 16'h4000;
            #1;

            check_outputs(4'd14, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern (starting at 14)", test_num);
            in = 16'h5555;
            #1;

            check_outputs(4'd14, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern (starting at 15)", test_num);
            in = 16'hAAAA;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 3 priority", test_num);
            in = 16'h0008;
            #1;

            check_outputs(4'd3, 1'b1);
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
        input [3:0] expected_pos;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: pos=%h, valid=%b",
                         pos, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h, valid=%b",
                         expected_pos, expected_valid);
                $display("  Got:      pos=%h, valid=%b",
                         pos, valid);
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
