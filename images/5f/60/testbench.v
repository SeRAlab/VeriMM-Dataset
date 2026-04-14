`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg sel;
    wire overflow;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .overflow(overflow),
        .s(s)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (sel=0), a=0x00, b=0x00", test_num);
        a = 8'h00;
        b = 8'h00;
        sel = 0;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (sel=0), a=0xFF, b=0xFF", test_num);
        a = 8'hFF;
        b = 8'hFF;
        sel = 0;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (sel=0), a=0xAA, b=0x55", test_num);
        a = 8'hAA;
        b = 8'h55;
        sel = 0;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (sel=0), a=0xF0, b=0x0F", test_num);
        a = 8'hF0;
        b = 8'h0F;
        sel = 0;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (sel=1), a=0x00, b=0x00 (No Carry)", test_num);
        a = 8'h00;
        b = 8'h00;
        sel = 1;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (sel=1), a=0x05, b=0x0A (No Carry)", test_num);
        a = 8'h05;
        b = 8'h0A;
        sel = 1;
        #1;

        check_outputs(1'b0, 8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (sel=1), a=0xFF, b=0x01 (Carry/Overflow)", test_num);
        a = 8'hFF;
        b = 8'h01;
        sel = 1;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (sel=1), a=0x80, b=0x80 (Carry/Overflow)", test_num);
        a = 8'h80;
        b = 8'h80;
        sel = 1;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (sel=1), a=0x7F, b=0x01 (No Carry)", test_num);
        a = 8'h7F;
        b = 8'h01;
        sel = 1;
        #1;

        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (sel=1), a=0xFE, b=0x02 (Carry/Overflow)", test_num);
        a = 8'hFE;
        b = 8'h02;
        sel = 1;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (sel=1), a=0xFF, b=0xFF (Carry/Overflow)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        sel = 1;
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (sel=0), a=0x12, b=0x34", test_num);
        a = 8'h12;
        b = 8'h34;
        sel = 0;
        #1;

        check_outputs(1'b0, 8'h26);
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
        input expected_overflow;
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, s=%h",
                         overflow, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, s=%h",
                         expected_overflow, expected_s);
                $display("  Got:      overflow=%b, s=%h",
                         overflow, s);
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
