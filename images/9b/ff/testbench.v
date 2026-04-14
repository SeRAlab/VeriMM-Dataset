`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg blank;
    reg [10:0] hc;
    reg [7:0] mem_value;
    reg [10:0] vc;
    wire [1:0] B;
    wire [2:0] G;
    wire [2:0] R;
    wire inside_image;
    wire [14:0] rom_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blank(blank),
        .hc(hc),
        .mem_value(mem_value),
        .vc(vc),
        .B(B),
        .G(G),
        .R(R),
        .inside_image(inside_image),
        .rom_addr(rom_addr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Blanking signal active", test_num);
            blank = 1;
            hc = 144;
            vc = 35;
            mem_value = 8'hFF;

            #1;


            check_outputs(2'b00, 3'b000, 3'b000, 1'b0, 15'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Outside sprite boundary (Top-Left)", test_num);
            blank = 0;
            hc = 10;
            vc = 10;
            mem_value = 8'hAA;

            #1;


            check_outputs(2'b00, 3'b000, 3'b000, 1'b0, 15'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sprite start coordinate (Top-Left corner)", test_num);
            blank = 0;
            hc = 144;
            vc = 35;
            mem_value = 8'b101_011_10;

            #1;


            check_outputs(2'b10, 3'b011, 3'b101, 1'b1, 15'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inside sprite area - Middle pixel", test_num);
            blank = 0;
            hc = 200;
            vc = 50;
            mem_value = 8'b010_110_01;



            #1;




            check_outputs(2'b01, 3'b110, 3'b010, 1'b1, 15'd2456);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Color extraction check - All bits set", test_num);
            blank = 0;
            hc = 145;
            vc = 35;
            mem_value = 8'hFF;

            #1;


            check_outputs(2'b11, 3'b111, 3'b111, 1'b1, 15'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right boundary of 160x120 sprite", test_num);
            blank = 0;
            hc = 303;
            vc = 35;
            mem_value = 8'h00;

            #1;


            check_outputs(2'b00, 3'b000, 3'b000, 1'b1, 15'd159);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bottom boundary of 160x120 sprite", test_num);
            blank = 0;
            hc = 144;
            vc = 154;
            mem_value = 8'h49;

            #1;


            check_outputs(2'b01, 3'b010, 3'b010, 1'b1, 15'd19040);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Just outside right boundary", test_num);
            blank = 0;
            hc = 304;
            vc = 35;
            mem_value = 8'hFF;

            #1;


            check_outputs(2'b00, 3'b000, 3'b000, 1'b0, 15'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Just outside bottom boundary", test_num);
            blank = 0;
            hc = 144;
            vc = 155;
            mem_value = 8'hFF;

            #1;


            check_outputs(2'b00, 3'b000, 3'b000, 1'b0, 15'h0000);
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
        input [1:0] expected_B;
        input [2:0] expected_G;
        input [2:0] expected_R;
        input expected_inside_image;
        input [14:0] expected_rom_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_inside_image === (expected_inside_image ^ inside_image ^ expected_inside_image) &&
                expected_rom_addr === (expected_rom_addr ^ rom_addr ^ expected_rom_addr)) begin
                $display("PASS");
                $display("  Outputs: B=%h, G=%h, R=%h, inside_image=%b, rom_addr=%h",
                         B, G, R, inside_image, rom_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h, G=%h, R=%h, inside_image=%b, rom_addr=%h",
                         expected_B, expected_G, expected_R, expected_inside_image, expected_rom_addr);
                $display("  Got:      B=%h, G=%h, R=%h, inside_image=%b, rom_addr=%h",
                         B, G, R, inside_image, rom_addr);
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
