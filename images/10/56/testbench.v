`timescale 1ns/1ps

module priority_encoder_16_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [3:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_16_to_4 dut (
        .in(in),
        .out(out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No inputs active (in=16'h0000)", test_num);
            in = 16'h0000;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LSB only (in=16'h0001)", test_num);
            in = 16'h0001;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB only (in=16'h8000)", test_num);
            in = 16'h8000;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle bit (in=16'h0080)", test_num);
            in = 16'h0080;
            #1;

            check_outputs(4'd7, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple bits - High priority (in=16'h8001)", test_num);
            in = 16'h8001;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple bits - Middle priority (in=16'h00F0)", test_num);
            in = 16'h00F0;
            #1;

            check_outputs(4'd7, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits active (in=16'hFFFF)", test_num);
            in = 16'hFFFF;
            #1;

            check_outputs(4'd15, 1'b1);
        end
    endcase


    task testcase008;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Scattered bits (in=16'h1234)", test_num);
            in = 16'h1234;
            #1;

            check_outputs(4'd12, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 1 (in=16'h0002)", test_num);
            in = 16'h0002;
            #1;

            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 14 priority (in=16'h7FFF)", test_num);
            in = 16'h7FFF;
            #1;

            check_outputs(4'd14, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_16_to_4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
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
        input [3:0] expected_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
