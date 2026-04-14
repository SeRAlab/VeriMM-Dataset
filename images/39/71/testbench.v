`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [20:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data_in(data_in),
        .encoded_out(encoded_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 16'h0000;
            #1;

            check_outputs(21'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 16'hFFFF;
            #1;

            check_outputs(21'h1FFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 16'h0001;
            #1;

            check_outputs(21'h000007);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 16'h8000;
            #1;

            check_outputs(21'h108009);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 16'h1234;
            #1;

            check_outputs(21'h02A3A1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 16'h5555;
            #1;

            check_outputs(21'h0A5527);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 16'hAAAA;
            #1;

            check_outputs(21'h15AAD9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [20:0] expected_encoded_out;
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
