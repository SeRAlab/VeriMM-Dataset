`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] char_in;
    wire [3:0] encoded_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char_in(char_in),
        .encoded_out(encoded_out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input A (0000) -> Expected Code '01'", test_num);
        char_in = 4'b0000;
        #1;

        check_outputs(4'b0001, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input B (0001) -> Expected Code '100'", test_num);
        char_in = 4'b0001;
        #1;

        check_outputs(4'b0100, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input C (0010) -> Expected Code '101'", test_num);
        char_in = 4'b0010;
        #1;

        check_outputs(4'b0101, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input D (0011) -> Expected Code '1100'", test_num);
        char_in = 4'b0011;
        #1;

        check_outputs(4'b1100, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input E (0100) -> Expected Code '1101'", test_num);
        char_in = 4'b0100;
        #1;

        check_outputs(4'b1101, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input F (0101) -> Expected Code '1110'", test_num);
        char_in = 4'b0101;
        #1;

        check_outputs(4'b1110, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input G (0110) -> Expected Code '1111'", test_num);
        char_in = 4'b0110;
        #1;

        check_outputs(4'b1111, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input Invalid (0111) -> Expected Code '0'", test_num);
        char_in = 4'b0111;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Input Invalid (1010) -> Expected Code '0'", test_num);
        char_in = 4'b1010;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Input Invalid (1111) -> Expected Code '0'", test_num);
        char_in = 4'b1111;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("huffman_encoder Testbench");
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
        input [3:0] expected_encoded_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, valid=%b",
                         encoded_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, valid=%b",
                         expected_encoded_out, expected_valid);
                $display("  Got:      encoded_out=%h, valid=%b",
                         encoded_out, valid);
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
