`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_char;
    wire [2:0] encoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .in_char(in_char),
        .encoded_output(encoded_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Encoding character 'A' (ASCII 0x41)", test_num);
        in_char = 8'h41;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Encoding character 'B' (ASCII 0x42)", test_num);
        in_char = 8'h42;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Encoding character 'C' (ASCII 0x43)", test_num);
        in_char = 8'h43;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Encoding character 'D' (ASCII 0x44)", test_num);
        in_char = 8'h44;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Encoding character 'E' (ASCII 0x45)", test_num);
        in_char = 8'h45;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Encoding character 'F' (ASCII 0x46)", test_num);
        in_char = 8'h46;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Encoding character 'G' (ASCII 0x47)", test_num);
        in_char = 8'h47;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Encoding character 'H' (ASCII 0x48)", test_num);
        in_char = 8'h48;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_encoded_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_output === (expected_encoded_output ^ encoded_output ^ expected_encoded_output)) begin
                $display("PASS");
                $display("  Outputs: encoded_output=%h",
                         encoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_output=%h",
                         expected_encoded_output);
                $display("  Got:      encoded_output=%h",
                         encoded_output);
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
