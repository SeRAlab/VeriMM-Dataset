`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] key_code;
    wire [7:0] ascii_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key_code(key_code),
        .ascii_code(ascii_code)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        key_code = 8'h45;
        #10;
        $display("Test %0d: key_code=0x45 (Digit 0)", test_num);
        #1;

        check_outputs(8'h30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        key_code = 8'h16;
        #10;
        $display("Test %0d: key_code=0x16 (Digit 1)", test_num);
        #1;

        check_outputs(8'h31);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        key_code = 8'h1E;
        #10;
        $display("Test %0d: key_code=0x1E (Digit 2)", test_num);
        #1;

        check_outputs(8'h32);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        key_code = 8'h26;
        #10;
        $display("Test %0d: key_code=0x26 (Digit 3)", test_num);
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        key_code = 8'h25;
        #10;
        $display("Test %0d: key_code=0x25 (Digit 4)", test_num);
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        key_code = 8'h2E;
        #10;
        $display("Test %0d: key_code=0x2E (Digit 5)", test_num);
        #1;

        check_outputs(8'h35);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        key_code = 8'h36;
        #10;
        $display("Test %0d: key_code=0x36 (Digit 6)", test_num);
        #1;

        check_outputs(8'h36);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        key_code = 8'h3D;
        #10;
        $display("Test %0d: key_code=0x3D (Digit 7)", test_num);
        #1;

        check_outputs(8'h37);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        key_code = 8'h3E;
        #10;
        $display("Test %0d: key_code=0x3E (Digit 8)", test_num);
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        key_code = 8'h46;
        #10;
        $display("Test %0d: key_code=0x46 (Digit 9)", test_num);
        #1;

        check_outputs(8'h39);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        key_code = 8'h1C;
        #10;
        $display("Test %0d: key_code=0x1C (Letter A)", test_num);
        #1;

        check_outputs(8'h41);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        key_code = 8'h32;
        #10;
        $display("Test %0d: key_code=0x32 (Letter B)", test_num);
        #1;

        check_outputs(8'h42);
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
        input [7:0] expected_ascii_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ascii_code === (expected_ascii_code ^ ascii_code ^ expected_ascii_code)) begin
                $display("PASS");
                $display("  Outputs: ascii_code=%h",
                         ascii_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ascii_code=%h",
                         expected_ascii_code);
                $display("  Got:      ascii_code=%h",
                         ascii_code);
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
