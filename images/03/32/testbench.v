`timescale 1ns/1ps

module priority_encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8to3 dut (
        .in(in),
        .out(out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No input active", test_num);
            in = 8'b0000_0000;
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Bit 0 (LSB) active", test_num);
            in = 8'b0000_0001;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bit 7 (MSB) active", test_num);
            in = 8'b1000_0000;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bit 4 active", test_num);
            in = 8'b0001_0000;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Priority check - Bit 1 vs Bit 0", test_num);
            in = 8'b0000_0011;
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority check - Bit 7 vs Bit 0", test_num);
            in = 8'b1000_0001;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Priority check - Bit 5 vs Bits 4, 3, 2", test_num);
            in = 8'b0011_1100;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All inputs active", test_num);
            in = 8'b1111_1111;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Mid-range bit 3 active", test_num);
            in = 8'b0000_1000;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Sparse bits active (6 and 2)", test_num);
            in = 8'b0100_0100;
            #1;

            check_outputs(3'd6, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_8to3 Testbench");
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
        input [2:0] expected_out;
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
