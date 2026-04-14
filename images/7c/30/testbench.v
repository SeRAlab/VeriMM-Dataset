`timescale 1ns/1ps

module encoder8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bin;
    wire [2:0] enc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder8to3 dut (
        .bin(bin),
        .enc(enc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: bin = 8'b00000001");
        bin = 8'b00000001;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: bin = 8'b00000010");
        bin = 8'b00000010;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: bin = 8'b00000100");
        bin = 8'b00000100;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: bin = 8'b00001000");
        bin = 8'b00001000;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: bin = 8'b00010000");
        bin = 8'b00010000;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: bin = 8'b00100000");
        bin = 8'b00100000;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: bin = 8'b01000000");
        bin = 8'b01000000;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: bin = 8'b10000000");
        bin = 8'b10000000;
        #1;

        check_outputs(3'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder8to3 Testbench");
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
        input [2:0] expected_enc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enc === (expected_enc ^ enc ^ expected_enc)) begin
                $display("PASS");
                $display("  Outputs: enc=%h",
                         enc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enc=%h",
                         expected_enc);
                $display("  Got:      enc=%h",
                         enc);
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
