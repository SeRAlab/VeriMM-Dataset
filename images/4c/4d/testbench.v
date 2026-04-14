`timescale 1ns/1ps

module priority_encoder8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder8bit dut (
        .in(in),
        .out(out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input all zeros", test_num);
        in = 8'b00000000;
        #1;

        check_outputs(3'b000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 0 high", test_num);
        in = 8'b00000001;
        #1;

        check_outputs(3'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 1 high", test_num);
        in = 8'b00000010;
        #1;

        check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 2 high", test_num);
        in = 8'b00000100;
        #1;

        check_outputs(3'd2, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 3 high", test_num);
        in = 8'b00001000;
        #1;

        check_outputs(3'd3, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 4 high", test_num);
        in = 8'b00010000;
        #1;

        check_outputs(3'd4, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 5 high", test_num);
        in = 8'b00100000;
        #1;

        check_outputs(3'd5, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 6 high", test_num);
        in = 8'b01000000;
        #1;

        check_outputs(3'd6, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 7 high", test_num);
        in = 8'b10000000;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple bits high (7 and 0) - Priority MSB", test_num);
        in = 8'b10000001;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lower nibble high - Priority bit 3", test_num);
        in = 8'b00001111;
        #1;

        check_outputs(3'd3, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All bits high - Priority bit 7", test_num);
        in = 8'b11111111;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sparse bits (6, 4, 2) - Priority bit 6", test_num);
        in = 8'b01010100;
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
        $display("priority_encoder8bit Testbench");
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
        testcase013();
        
        
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
