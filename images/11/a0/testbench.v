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
        test_num = 1;
        char_in = 4'h0;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        char_in = 4'h1;
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        char_in = 4'h2;
        #1;

        check_outputs(8'b00000110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        char_in = 4'h3;
        #1;

        check_outputs(8'b00001110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        char_in = 4'h4;
        #1;

        check_outputs(8'b00011110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        char_in = 4'h5;
        #1;

        check_outputs(8'b00111110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        char_in = 4'h6;
        #1;

        check_outputs(8'b01111110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        char_in = 4'h7;
        #1;

        check_outputs(8'b11111110);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        char_in = 4'h8;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        char_in = 4'h9;
        #1;

        check_outputs(8'b10101010);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        char_in = 4'hA;
        #1;

        check_outputs(8'b01010101);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        char_in = 4'hB;
        #1;

        check_outputs(8'b11001100);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        char_in = 4'hC;
        #1;

        check_outputs(8'b00110011);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        char_in = 4'hD;
        #1;

        check_outputs(8'b11110000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        char_in = 4'hE;
        #1;

        check_outputs(8'b00001111);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        char_in = 4'hF;
        #1;

        check_outputs(8'b10011001);
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
