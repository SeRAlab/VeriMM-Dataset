`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] M;
    reg [7:0] face;
    reg [9:0] hc;
    reg [3:0] posx;
    reg [3:0] posy;
    reg [9:0] vc;
    reg vidon;
    wire [3:0] C1;
    wire [3:0] R1;
    wire [1:0] blue;
    wire [2:0] green;
    wire [2:0] red;
    wire [7:0] rom_addr16;
    wire [9:0] rom_addr26;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .face(face),
        .hc(hc),
        .posx(posx),
        .posy(posy),
        .vc(vc),
        .vidon(vidon),
        .C1(C1),
        .R1(R1),
        .blue(blue),
        .green(green),
        .red(red),
        .rom_addr16(rom_addr16),
        .rom_addr26(rom_addr26)
    );
    task testcase001;

        begin
            test_num = 1;
            vidon = 0; hc = 10'd100; vc = 10'd100;
            M = 8'hFF; face = 8'hAA; posx = 4'h0; posy = 4'h0;
            #10;

            #1;


            check_outputs(4'h6, 4'h6, 2'b00, 3'b000, 3'b000, 8'h44, 10'h06A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            vidon = 1; hc = 10'd0; vc = 10'd0;
            M = 8'h00; face = 8'h00; posx = 4'h0; posy = 4'h0;
            #10;
            #1;

            check_outputs(4'h0, 4'h0, 2'h0, 3'h0, 3'h0, 8'h00, 10'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            vidon = 1; hc = 10'd32; vc = 10'd32;
            M = 8'h55; face = 8'h11; posx = 4'h2; posy = 4'h2;
            #10;

            #1;


            check_outputs(4'h2, 4'h2, 2'h1, 3'h2, 3'h2, 8'h20, 10'h011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            vidon = 1; hc = 10'd15; vc = 10'd7;
            M = 8'hC0; face = 8'hF0; posx = 4'h0; posy = 4'h0;
            #10;
            #1;

            check_outputs(4'h0, 4'h0, 2'h0, 3'h0, 3'h6, 8'h7F, 10'h0F0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            vidon = 1; hc = 10'd639; vc = 10'd479;
            M = 8'h00; face = 8'hFF; posx = 4'hF; posy = 4'hF;
            #10;
            #1;

            check_outputs(4'hF, 4'hD, 2'h0, 3'h0, 3'h0, 8'hFF, 10'h0FF);
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
        input [3:0] expected_C1;
        input [3:0] expected_R1;
        input [1:0] expected_blue;
        input [2:0] expected_green;
        input [2:0] expected_red;
        input [7:0] expected_rom_addr16;
        input [9:0] expected_rom_addr26;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C1 === (expected_C1 ^ C1 ^ expected_C1) &&
                expected_R1 === (expected_R1 ^ R1 ^ expected_R1) &&
                expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_rom_addr16 === (expected_rom_addr16 ^ rom_addr16 ^ expected_rom_addr16) &&
                expected_rom_addr26 === (expected_rom_addr26 ^ rom_addr26 ^ expected_rom_addr26)) begin
                $display("PASS");
                $display("  Outputs: C1=%h, R1=%h, blue=%h, green=%h, red=%h, rom_addr16=%h, rom_addr26=%h",
                         C1, R1, blue, green, red, rom_addr16, rom_addr26);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C1=%h, R1=%h, blue=%h, green=%h, red=%h, rom_addr16=%h, rom_addr26=%h",
                         expected_C1, expected_R1, expected_blue, expected_green, expected_red, expected_rom_addr16, expected_rom_addr26);
                $display("  Got:      C1=%h, R1=%h, blue=%h, green=%h, red=%h, rom_addr16=%h, rom_addr26=%h",
                         C1, R1, blue, green, red, rom_addr16, rom_addr26);
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
