`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] M;
    reg [7:0] SW;
    reg [9:0] hc;
    reg [9:0] vc;
    reg vidon;
    wire [7:0] B;
    wire [7:0] G;
    wire [7:0] R;
    wire [3:0] rom_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .SW(SW),
        .hc(hc),
        .vc(vc),
        .vidon(vidon),
        .B(B),
        .G(G),
        .R(R),
        .rom_addr(rom_addr)
    );
    task testcase001;

        begin
            $display("Testcase 001: Video Off (vidon = 0)");
            test_num = 1;
            vidon = 0;
            hc = 10'd100;
            vc = 10'd50;
            M = 16'hFFFF;
            SW = 8'hFF;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 4'h2);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: ROM Address Mapping");
            test_num = 2;
            vidon = 1;
            hc = 10'd0;
            vc = 10'd7;
            M = 16'h0000;
            SW = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 4'h7);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Foreground Pixel (Active bit in M)");
            test_num = 3;
            vidon = 1;
            hc = 10'd0;
            vc = 10'd0;
            M = 16'h8000;
            SW = 8'b111_000_00;




            #1;





            check_outputs(8'h00, 8'h00, 8'hFF, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Background Pixel (Inactive bit in M)");
            test_num = 4;
            vidon = 1;
            hc = 10'd8;
            vc = 10'd0;
            M = 16'hFF00;
            SW = 8'hFF;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Color Switching via SW");
            test_num = 5;
            vidon = 1;
            hc = 10'd0;
            vc = 10'd0;
            M = 16'hFFFF;


            SW = 8'b000_111_00;
            #1;

            check_outputs(8'h00, 8'hFF, 8'h00, 4'h0);


            SW = 8'b000_000_11;
            #1;

            check_outputs(8'hFF, 8'h00, 8'h00, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Vertical Boundary rom_addr");
            test_num = 6;
            vidon = 1;
            hc = 10'd10;
            vc = 10'd31;
            M = 16'h0000;
            SW = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 4'hF);
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
        input [7:0] expected_B;
        input [7:0] expected_G;
        input [7:0] expected_R;
        input [3:0] expected_rom_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_rom_addr === (expected_rom_addr ^ rom_addr ^ expected_rom_addr)) begin
                $display("PASS");
                $display("  Outputs: B=%h, G=%h, R=%h, rom_addr=%h",
                         B, G, R, rom_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h, G=%h, R=%h, rom_addr=%h",
                         expected_B, expected_G, expected_R, expected_rom_addr);
                $display("  Got:      B=%h, G=%h, R=%h, rom_addr=%h",
                         B, G, R, rom_addr);
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
