`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [3:0] code_length;
    wire [7:0] huffman_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .symbol(symbol),
        .code_length(code_length),
        .huffman_code(huffman_code)
    );
    task testcase001;

    begin
        $display("Running testcase001: Symbol 0...");
        symbol = 4'd0;
        #1;

        check_outputs(4'd2, 8'b00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Symbol 1...");
        symbol = 4'd1;
        #1;

        check_outputs(4'd2, 8'b01000000);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Symbol 3...");
        symbol = 4'd3;
        #1;

        check_outputs(4'd3, 8'b11000000);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Symbol 5...");
        symbol = 4'd5;
        #1;

        check_outputs(4'd5, 8'b11110000);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Symbol 8...");
        symbol = 4'd8;
        #1;

        check_outputs(4'd8, 8'b11111110);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Symbol 9...");
        symbol = 4'd9;
        #1;

        check_outputs(4'd8, 8'b11111111);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Unassigned Symbol 15...");
        symbol = 4'd15;
        #1;

        check_outputs(4'd0, 8'b00000000);
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
        input [3:0] expected_code_length;
        input [7:0] expected_huffman_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code_length === (expected_code_length ^ code_length ^ expected_code_length) &&
                expected_huffman_code === (expected_huffman_code ^ huffman_code ^ expected_huffman_code)) begin
                $display("PASS");
                $display("  Outputs: code_length=%h, huffman_code=%h",
                         code_length, huffman_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_length=%h, huffman_code=%h",
                         expected_code_length, expected_huffman_code);
                $display("  Got:      code_length=%h, huffman_code=%h",
                         code_length, huffman_code);
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
