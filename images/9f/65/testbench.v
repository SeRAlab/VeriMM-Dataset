`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ActR;
    reg [3:0] MC;
    reg [3:0] MG;
    reg [3:0] MR;
    reg border;
    reg flash_GM;
    reg flash_RM;
    reg flash_blue;
    reg slug;
    reg slug_magenta;
    wire [1:0] Blue;
    wire [2:0] Green;
    wire [2:0] Red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ActR(ActR),
        .MC(MC),
        .MG(MG),
        .MR(MR),
        .border(border),
        .flash_GM(flash_GM),
        .flash_RM(flash_RM),
        .flash_blue(flash_blue),
        .slug(slug),
        .slug_magenta(slug_magenta),
        .Blue(Blue),
        .Green(Green),
        .Red(Red)
    );
    task testcase001;

    begin
        $display("Testcase 001: All Zeros / Idle");
        ActR = 0; MC = 4'h0; MG = 4'h0; MR = 4'h0;
        border = 0; flash_GM = 0; flash_RM = 0; flash_blue = 0;
        slug = 0; slug_magenta = 0;

        #1;


        check_outputs(2'b00, 3'b000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Border Active");
        ActR = 1; MC = 4'hF; MG = 4'hF; MR = 4'hF;
        border = 1; flash_GM = 1; flash_RM = 1; flash_blue = 1;
        slug = 1; slug_magenta = 1;


        #1;



        check_outputs(2'b11, 3'b111, 3'b111);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: ActR Active - Pure Red background");
        border = 0; slug = 0; slug_magenta = 0;
        ActR = 1; MR = 4'b1110; MG = 4'b0000; MC = 4'b0000;
        flash_RM = 0; flash_GM = 0; flash_blue = 0;

        #1;


        check_outputs(2'b00, 3'b000, 3'b111);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: ActR Active - Pure Green background");
        border = 0; slug = 0; slug_magenta = 0;
        ActR = 1; MR = 4'b0000; MG = 4'b1110; MC = 4'b0000;
        flash_RM = 0; flash_GM = 0; flash_blue = 0;
        #1;

        check_outputs(2'b00, 3'b111, 3'b000);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: ActR Active - Pure Blue background");
        border = 0; slug = 0; slug_magenta = 0;
        ActR = 1; MR = 4'b0000; MG = 4'b0000; MC = 4'b1100;
        flash_RM = 0; flash_GM = 0; flash_blue = 0;
        #1;

        check_outputs(2'b11, 3'b000, 3'b000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Slug Priority Over Background");
        border = 0; slug = 1; slug_magenta = 0;
        ActR = 1; MR = 4'hF; MG = 4'hF; MC = 4'hF;
        flash_RM = 0; flash_GM = 0; flash_blue = 0;

        #1;


        check_outputs(2'b00, 3'b000, 3'b000);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Slug Magenta Priority");
        border = 0; slug = 0; slug_magenta = 1;
        ActR = 1; MR = 4'h0; MG = 4'hF; MC = 4'h0;
        flash_RM = 0; flash_GM = 0; flash_blue = 0;

        #1;


        check_outputs(2'b11, 3'b000, 3'b111);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Flashing Signals (ActR=1)");
        border = 0; slug = 0; slug_magenta = 0;
        ActR = 1; MR = 4'h0; MG = 4'h0; MC = 4'h0;
        flash_RM = 1; flash_GM = 1; flash_blue = 1;

        #1;


        check_outputs(2'b11, 3'b111, 3'b111);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Mixed Background and Flash");
        border = 0; slug = 0; slug_magenta = 0;
        ActR = 1; MR = 4'b1010; MG = 4'b0000; MC = 4'b0100;
        flash_RM = 0; flash_GM = 1; flash_blue = 0;

        #1;


        check_outputs(2'b01, 3'b111, 3'b101);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: ActR Inactive");
        border = 0; slug = 0; slug_magenta = 0;
        ActR = 0; MR = 4'hF; MG = 4'hF; MC = 4'hF;
        flash_RM = 1; flash_GM = 1; flash_blue = 1;

        #1;


        check_outputs(2'b00, 3'b000, 3'b000);
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
        input [1:0] expected_Blue;
        input [2:0] expected_Green;
        input [2:0] expected_Red;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Blue === (expected_Blue ^ Blue ^ expected_Blue) &&
                expected_Green === (expected_Green ^ Green ^ expected_Green) &&
                expected_Red === (expected_Red ^ Red ^ expected_Red)) begin
                $display("PASS");
                $display("  Outputs: Blue=%h, Green=%h, Red=%h",
                         Blue, Green, Red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Blue=%h, Green=%h, Red=%h",
                         expected_Blue, expected_Green, expected_Red);
                $display("  Got:      Blue=%h, Green=%h, Red=%h",
                         Blue, Green, Red);
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
