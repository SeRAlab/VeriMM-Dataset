`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] symbol;
    wire [3:0] encoded_length;
    wire [31:0] encoded_output;

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
        test_num = 1;
        $display("Test Case %0d: Input symbol 8'h00", test_num);
        symbol = 8'h00;


        #1;



        check_outputs(4'd8, 32'h000000AA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input symbol 8'h41 ('A')", test_num);
        symbol = 8'h41;
        #1;

        check_outputs(4'd6, 32'h0000002B);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input symbol 8'h61 ('a')", test_num);
        symbol = 8'h61;
        #1;

        check_outputs(4'd4, 32'h00000003);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input symbol 8'h20 (Space)", test_num);
        symbol = 8'h20;
        #1;

        check_outputs(4'd3, 32'h00000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input symbol 8'hFF", test_num);
        symbol = 8'hFF;
        #1;

        check_outputs(4'd12, 32'h00000C1F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input symbol 8'h0A (LF)", test_num);
        symbol = 8'h0A;
        #1;

        check_outputs(4'd9, 32'h00000150);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input symbol 8'h30 ('0')", test_num);
        symbol = 8'h30;
        #1;

        check_outputs(4'd7, 32'h0000004E);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input symbol 8'h7E ('~')", test_num);
        symbol = 8'h7E;
        #1;

        check_outputs(4'd10, 32'h000002FF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Input symbol 8'h55", test_num);
        symbol = 8'h55;
        #1;

        check_outputs(4'd8, 32'h00000055);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Input symbol 8'hE1", test_num);
        symbol = 8'hE1;
        #1;

        check_outputs(4'd11, 32'h000004A2);
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
        input [3:0] expected_encoded_length;
        input [31:0] expected_encoded_output;
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
