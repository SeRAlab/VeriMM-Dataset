`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] in;
    wire [2:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .enable(enable),
        .in(in),
        .out(out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable signal is low - Output should be 0 and invalid", test_num);
            enable = 0;
            in = 8'b1111_1111;
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable signal high, but no inputs asserted", test_num);
            enable = 1;
            in = 8'b0000_0000;
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only highest priority bit (Bit 7) asserted", test_num);
            enable = 1;
            in = 8'b1000_0000;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only lowest priority bit (Bit 0) asserted", test_num);
            enable = 1;
            in = 8'b0000_0001;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple bits (7 and 0) asserted - Priority check for Bit 7", test_num);
            enable = 1;
            in = 8'b1000_0001;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple bits (3, 2, 1) asserted - Priority check for Bit 3", test_num);
            enable = 1;
            in = 8'b0000_1110;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All input bits asserted - Priority check for Bit 7", test_num);
            enable = 1;
            in = 8'b1111_1111;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle bit (Bit 4) asserted", test_num);
            enable = 1;
            in = 8'b0001_0000;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamically disabling the encoder while input is present", test_num);
            enable = 1;
            in = 8'b0100_0000;
            #1;
            enable = 0;
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking 1s test (Bits 1 to 6)", test_num);
            enable = 1;

            in = 8'h02; #1;
 check_outputs(3'd1, 1'b1);
            in = 8'h04; #1;
 check_outputs(3'd2, 1'b1);
            in = 8'h10; #1;
 check_outputs(3'd4, 1'b1);
            in = 8'h20; #1;
 check_outputs(3'd5, 1'b1);
            in = 8'h40; #1;
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
        $display("priority_encoder Testbench");
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
