`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hex_value;
    wire [5:0] char_rom_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex_value(hex_value),
        .char_rom_address(char_rom_address)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input hex 0x0", test_num);
        hex_value = 4'h0;
        #1;

        check_outputs(6'o00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input hex 0x1", test_num);
        hex_value = 4'h1;
        #1;

        check_outputs(6'o01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input hex 0x2", test_num);
        hex_value = 4'h2;
        #1;

        check_outputs(6'o02);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input hex 0x3", test_num);
        hex_value = 4'h3;
        #1;

        check_outputs(6'o03);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input hex 0x4", test_num);
        hex_value = 4'h4;
        #1;

        check_outputs(6'o04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input hex 0x5", test_num);
        hex_value = 4'h5;
        #1;

        check_outputs(6'o05);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input hex 0x6", test_num);
        hex_value = 4'h6;
        #1;

        check_outputs(6'o06);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input hex 0x7", test_num);
        hex_value = 4'h7;
        #1;

        check_outputs(6'o07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input hex 0x8", test_num);
        hex_value = 4'h8;
        #1;

        check_outputs(6'o10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input hex 0x9", test_num);
        hex_value = 4'h9;
        #1;

        check_outputs(6'o11);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Input hex 0xA", test_num);
        hex_value = 4'hA;
        #1;

        check_outputs(6'o12);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Input hex 0xB", test_num);
        hex_value = 4'hB;
        #1;

        check_outputs(6'o13);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: Input hex 0xC", test_num);
        hex_value = 4'hC;
        #1;

        check_outputs(6'o14);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: Input hex 0xD", test_num);
        hex_value = 4'hD;
        #1;

        check_outputs(6'o15);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: Input hex 0xE", test_num);
        hex_value = 4'hE;
        #1;

        check_outputs(6'o16);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: Input hex 0xF", test_num);
        hex_value = 4'hF;
        #1;

        check_outputs(6'o17);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [5:0] expected_char_rom_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_char_rom_address === (expected_char_rom_address ^ char_rom_address ^ expected_char_rom_address)) begin
                $display("PASS");
                $display("  Outputs: char_rom_address=%h",
                         char_rom_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: char_rom_address=%h",
                         expected_char_rom_address);
                $display("  Got:      char_rom_address=%h",
                         char_rom_address);
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
