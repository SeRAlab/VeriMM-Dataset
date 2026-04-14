`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [3:0] encoded_length;
    wire [3:0] encoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .symbol(symbol),
        .encoded_length(encoded_length),
        .encoded_output(encoded_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symbol 0 (Expected Code: 00, Length: 2)", test_num);
        symbol = 4'd0;
        #1;

        check_outputs(4'd2, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symbol 1 (Expected Code: 01, Length: 2)", test_num);
        symbol = 4'd1;
        #1;

        check_outputs(4'd2, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symbol 2 (Expected Code: 10, Length: 2)", test_num);
        symbol = 4'd2;
        #1;

        check_outputs(4'd2, 4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symbol 3 (Expected Code: 110, Length: 3)", test_num);
        symbol = 4'd3;
        #1;

        check_outputs(4'd3, 4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symbol 4 (Expected Code: 1110, Length: 4)", test_num);
        symbol = 4'd4;
        #1;

        check_outputs(4'd4, 4'b1110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symbol 5 (Expected Code: 1111, Length: 4)", test_num);
        symbol = 4'd5;
        #1;

        check_outputs(4'd4, 4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symbol 6 (Undefined symbol, expected length 0)", test_num);
        symbol = 4'd6;
        #1;

        check_outputs(4'd0, 4'b0000);
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
        input [3:0] expected_encoded_length;
        input [3:0] expected_encoded_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_length === (expected_encoded_length ^ encoded_length ^ expected_encoded_length) &&
                expected_encoded_output === (expected_encoded_output ^ encoded_output ^ expected_encoded_output)) begin
                $display("PASS");
                $display("  Outputs: encoded_length=%h, encoded_output=%h",
                         encoded_length, encoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_length=%h, encoded_output=%h",
                         expected_encoded_length, expected_encoded_output);
                $display("  Got:      encoded_length=%h, encoded_output=%h",
                         encoded_length, encoded_output);
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
