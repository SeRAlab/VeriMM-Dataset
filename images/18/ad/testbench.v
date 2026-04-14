`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] frequencies;
    wire [15:0] codes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .frequencies(frequencies),
        .codes(codes)
    );
    task testcase001;

        begin
            $display("Testcase 001: All frequencies zero");
            test_num = 1;
            frequencies = 16'h0000;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All frequencies maximum (11 binary)");
            test_num = 2;
            frequencies = 16'hFFFF;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single dominant character (C0)");
            test_num = 3;
            frequencies = 16'hC000;


            #1;



            check_outputs(16'h0055);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Two dominant characters (C0, C1)");
            test_num = 4;
            frequencies = 16'hF000;
            #1;

            check_outputs(16'h01AA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Gradient distribution");
            test_num = 5;
            frequencies = 16'hE4E4;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: High frequency at boundaries (C0, C7)");
            test_num = 6;
            frequencies = 16'hC003;
            #1;

            check_outputs(16'h0FF0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternating high/low frequencies");
            test_num = 7;
            frequencies = 16'hC0C0;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_codes;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codes === (expected_codes ^ codes ^ expected_codes)) begin
                $display("PASS");
                $display("  Outputs: codes=%h",
                         codes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codes=%h",
                         expected_codes);
                $display("  Got:      codes=%h",
                         codes);
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
