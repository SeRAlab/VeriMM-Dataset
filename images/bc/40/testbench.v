`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] color;
    wire [7:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .color(color),
        .rgb(rgb)
    );
    task testcase001;

    begin
        $display("Testcase 001: Input 3'b000 (Background)");
        test_num = 1;
        color = 3'b000;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Input 3'b001 (Spaceship)");
        test_num = 2;
        color = 3'b001;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Input 3'b010 (Alien 1)");
        test_num = 3;
        color = 3'b010;

        #1;


        check_outputs(8'hA0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Input 3'b011 (Alien 2)");
        test_num = 4;
        color = 3'b011;

        #1;


        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Input 3'b100 (Laser)");
        test_num = 5;
        color = 3'b100;

        #1;


        check_outputs(8'hE0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Input 3'b101 (Power-up)");
        test_num = 6;
        color = 3'b101;

        #1;


        check_outputs(8'h1F);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Input 3'b110 (Shield)");
        test_num = 7;
        color = 3'b110;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Input 3'b111 (Explosion)");
        test_num = 8;
        color = 3'b111;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_rgb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
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
