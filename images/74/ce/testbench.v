`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [2:0] code_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .data_in(data_in),
        .code_out(code_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: No bits set (Input: 00000000)");
            data_in = 8'b0000_0000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Bit 0 set (Input: 00000001)");
            data_in = 8'b0000_0001;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Bit 1 set (Input: 00000010)");
            data_in = 8'b0000_0010;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Bit 2 set (Input: 00000100)");
            data_in = 8'b0000_0100;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Bit 3 set (Input: 00001000)");
            data_in = 8'b0000_1000;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Bit 4 set (Input: 00010000)");
            data_in = 8'b0001_0000;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Bit 5 set (Input: 00100000)");
            data_in = 8'b0010_0000;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Bit 6 set (Input: 01000000)");
            data_in = 8'b0100_0000;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Bit 7 set (Input: 10000000)");
            data_in = 8'b1000_0000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Multiple bits (7 and 0), Bit 7 Priority");
            data_in = 8'b1000_0001;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Multiple bits (3, 2, 1), Bit 3 Priority");
            data_in = 8'b0000_1110;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: All bits set, Bit 7 Priority");
            data_in = 8'b1111_1111;
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_code_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h",
                         code_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h",
                         expected_code_out);
                $display("  Got:      code_out=%h",
                         code_out);
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
