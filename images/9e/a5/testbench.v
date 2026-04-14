`timescale 1ns/1ps

module decoder_3to8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg en;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_3to8 dut (
        .a(a),
        .en(en),
        .y(y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Enable low, Input 000");
            en = 0;
            a = 3'b000;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable low, Input 111");
            en = 0;
            a = 3'b111;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable high, Input 000");
            en = 1;
            a = 3'b000;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable high, Input 001");
            en = 1;
            a = 3'b001;
            #1;

            check_outputs(8'b0000_0010);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable high, Input 010");
            en = 1;
            a = 3'b010;
            #1;

            check_outputs(8'b0000_0100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable high, Input 011");
            en = 1;
            a = 3'b011;
            #1;

            check_outputs(8'b0000_1000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enable high, Input 100");
            en = 1;
            a = 3'b100;
            #1;

            check_outputs(8'b0001_0000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable high, Input 101");
            en = 1;
            a = 3'b101;
            #1;

            check_outputs(8'b0010_0000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Enable high, Input 110");
            en = 1;
            a = 3'b110;
            #1;

            check_outputs(8'b0100_0000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Enable high, Input 111");
            en = 1;
            a = 3'b111;
            #1;

            check_outputs(8'b1000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_3to8 Testbench");
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
