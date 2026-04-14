`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [8:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero addition (0 + 0)", test_num);
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Max values without overflow (127 + 128)", test_num);
        a = 8'd127;
        b = 8'd128;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Smallest overflow (128 + 128)", test_num);
        a = 8'd128;
        b = 8'd128;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Max values with overflow (255 + 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(9'h1FE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: One input zero (0 + 255)", test_num);
        a = 8'h00;
        b = 8'hFF;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: One bit carry trigger (255 + 1)", test_num);
        a = 8'hFF;
        b = 8'h01;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Alternating bits (0xAA + 0x55)", test_num);
        a = 8'hAA;
        b = 8'h55;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Carry bit from mid-range values (0x80 + 0x81)", test_num);
        a = 8'h80;
        b = 8'h81;
        #1;

        check_outputs(9'h101);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Arbitrary small values (0x12 + 0x34)", test_num);
        a = 8'h12;
        b = 8'h34;
        #1;

        check_outputs(9'h046);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Boundary check for lower nibble carry (0x0F + 0x01)", test_num);
        a = 8'h0F;
        b = 8'h01;
        #1;

        check_outputs(9'h010);
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
        input [8:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
