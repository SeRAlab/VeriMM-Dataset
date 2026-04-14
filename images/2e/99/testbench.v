`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] char;
    wire [3:0] code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char(char),
        .code(code)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Character A (000)", test_num);
            char = 3'b000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Character B (001)", test_num);
            char = 3'b001;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Character C (010)", test_num);
            char = 3'b010;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Character D (011)", test_num);
            char = 3'b011;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Character E (100)", test_num);
            char = 3'b100;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid/Undefined Input (111)", test_num);
            char = 3'b111;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code === (expected_code ^ code ^ expected_code)) begin
                $display("PASS");
                $display("  Outputs: code=%h",
                         code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code=%h",
                         expected_code);
                $display("  Got:      code=%h",
                         code);
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
