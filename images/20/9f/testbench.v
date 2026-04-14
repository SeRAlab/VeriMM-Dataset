`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] char_in;
    wire [7:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char_in(char_in),
        .encoded_out(encoded_out)
    );
    task testcase001;

    begin
        $display("Test Case 001: char_in = 0");
        char_in = 4'd0;
        #1;

        check_outputs(8'b000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: char_in = 1");
        char_in = 4'd1;
        #1;

        check_outputs(8'b001);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: char_in = 2");
        char_in = 4'd2;
        #1;

        check_outputs(8'b010);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: char_in = 3");
        char_in = 4'd3;
        #1;

        check_outputs(8'b011);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: char_in = 4");
        char_in = 4'd4;
        #1;

        check_outputs(8'b100);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: char_in = 5");
        char_in = 4'd5;
        #1;

        check_outputs(8'b101);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: char_in = 6");
        char_in = 4'd6;
        #1;

        check_outputs(8'b110);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: char_in = 7");
        char_in = 4'd7;
        #1;

        check_outputs(8'b111);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: char_in = 8");
        char_in = 4'd8;
        #1;

        check_outputs(8'b00);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: char_in = 9");
        char_in = 4'd9;
        #1;

        check_outputs(8'b01);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: char_in = 10");
        char_in = 4'd10;
        #1;

        check_outputs(8'b10);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: char_in = 11");
        char_in = 4'd11;
        #1;

        check_outputs(8'b11);
    end
        endtask

    task testcase013;

    begin
        $display("Test Case 013: char_in = 12");
        char_in = 4'd12;
        #1;

        check_outputs(8'b00000);
    end
        endtask

    task testcase014;

    begin
        $display("Test Case 014: char_in = 13");
        char_in = 4'd13;
        #1;

        check_outputs(8'b00001);
    end
        endtask

    task testcase015;

    begin
        $display("Test Case 015: char_in = 14");
        char_in = 4'd14;
        #1;

        check_outputs(8'b00010);
    end
        endtask

    task testcase016;

    begin
        $display("Test Case 016: char_in = 15");
        char_in = 4'd15;
        #1;

        check_outputs(8'b00011);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [7:0] expected_encoded_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
