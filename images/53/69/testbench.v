`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .enable(enable),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Enable Low - Input 0");
            enable = 0;
            in = 4'h0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable Low - Input 15");
            enable = 0;
            in = 4'hF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable High - Input 0");
            enable = 1;
            in = 4'h0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable High - Input 1");
            enable = 1;
            in = 4'h1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable High - Input 2");
            enable = 1;
            in = 4'h2;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable High - Input 3");
            enable = 1;
            in = 4'h3;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enable High - Input 4");
            enable = 1;
            in = 4'h4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable High - Input 5");
            enable = 1;
            in = 4'h5;
            #1;

            check_outputs(16'h0020);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Enable High - Input 6");
            enable = 1;
            in = 4'h6;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Enable High - Input 7");
            enable = 1;
            in = 4'h7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Enable High - Input 8");
            enable = 1;
            in = 4'h8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Enable High - Input 9");
            enable = 1;
            in = 4'h9;
            #1;

            check_outputs(16'h0200);
        end
        endtask

    task testcase013;

        begin
            $display("Testcase 013: Enable High - Input 10");
            enable = 1;
            in = 4'hA;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase014;

        begin
            $display("Testcase 014: Enable High - Input 11");
            enable = 1;
            in = 4'hB;
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase015;

        begin
            $display("Testcase 015: Enable High - Input 12");
            enable = 1;
            in = 4'hC;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase016;

        begin
            $display("Testcase 016: Enable High - Input 13");
            enable = 1;
            in = 4'hD;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase017;

        begin
            $display("Testcase 017: Enable High - Input 14");
            enable = 1;
            in = 4'hE;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase018;

        begin
            $display("Testcase 018: Enable High - Input 15");
            enable = 1;
            in = 4'hF;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase019;

        begin
            $display("Testcase 019: Dynamic Disable Check");
            enable = 1; in = 4'h5; #1;
            enable = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16 Testbench");
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
        testcase017();
        testcase018();
        testcase019();
        
        
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
