`timescale 1ns/1ps

module priority_encoder_4to2_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [1:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4to2 dut (
        .in(in),
        .out(out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No inputs active", test_num);
            in = 4'b0000;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 0 active", test_num);
            in = 4'b0001;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 1 active", test_num);
            in = 4'b0010;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 2 active", test_num);
            in = 4'b0100;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 3 active", test_num);
            in = 4'b1000;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple inputs (3 and 0 active) - Priority Check", test_num);
            in = 4'b1001;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple inputs (2, 1 and 0 active) - Priority Check", test_num);
            in = 4'b0111;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple inputs (1 and 0 active) - Priority Check", test_num);
            in = 4'b0011;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs active - Priority Check", test_num);
            in = 4'b1111;
            #1;

            check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_out;
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
