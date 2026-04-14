`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero inputs (0 * 0)", test_num);
        a = 8'd0;
        b = 8'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Maximum inputs (255 * 255 = 65025/0xFE01)", test_num);
        a = 8'd255;
        b = 8'd255;
        #1;

        check_outputs(8'hE0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Low value result (1 * 1 = 1)", test_num);
        a = 8'd1;
        b = 8'd1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Lower boundary check (16 * 1 = 16/0x0010)", test_num);
        a = 8'd16;
        b = 8'd1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Boundary check - just below (15 * 1 = 15/0x000F)", test_num);
        a = 8'd15;
        b = 8'd1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Full lower byte (255 * 1 = 255/0x00FF)", test_num);
        a = 8'd255;
        b = 8'd1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Power of 2 crossing (128 * 32 = 4096/0x1000)", test_num);
        a = 8'd128;
        b = 8'd32;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bit 11 saturation check (255 * 16 = 4080/0x0FF0)", test_num);
        a = 8'd255;
        b = 8'd16;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Arbitrary multiplication (100 * 100 = 10000/0x2710)", test_num);
        a = 8'd100;
        b = 8'd100;
        #1;

        check_outputs(8'h71);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Arbitrary multiplication (45 * 123 = 5535/0x159F)", test_num);
        a = 8'd45;
        b = 8'd123;
        #1;

        check_outputs(8'h59);
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
        input [7:0] expected_out;
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
