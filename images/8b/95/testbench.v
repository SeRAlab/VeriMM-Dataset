`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg select;
    reg [2:0] vec;
    wire [7:0] min;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] outv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .select(select),
        .vec(vec),
        .min(min),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .outv(outv)
    );
    task testcase001;

    begin

        a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40;
        vec = 3'b101; select = 1'b0;
        $display("Testcase001: a=10, b=20, c=30, d=40, vec=3'b101, select=0");
        #1;

        check_outputs(8'd10, 1'b1, 1'b1, 1'b1, 3'b111);
    end
        endtask

    task testcase002;

    begin

        a = 8'd50; b = 8'd5; c = 8'd60; d = 8'd70;
        vec = 3'b101; select = 1'b1;
        $display("Testcase002: a=50, b=5, c=60, d=70, vec=3'b101, select=1");
        #1;

        check_outputs(8'd5, 1'b0, 1'b0, 1'b0, 3'b000);
    end
        endtask

    task testcase003;

    begin

        a = 8'd100; b = 8'd100; c = 8'd20; d = 8'd100;
        vec = 3'b010; select = 1'b0;
        $display("Testcase003: a=100, b=100, c=20, d=100, vec=3'b010, select=0");
        #1;

        check_outputs(8'd20, 1'b0, 1'b0, 1'b0, 3'b000);
    end
        endtask

    task testcase004;

    begin

        a = 8'd120; b = 8'd120; c = 8'd120; d = 8'd80;
        vec = 3'b010; select = 1'b1;
        $display("Testcase004: a=120, b=120, c=120, d=80, vec=3'b010, select=1");
        #1;

        check_outputs(8'd80, 1'b1, 1'b1, 1'b1, 3'b111);
    end
        endtask

    task testcase005;

    begin

        a = 8'd42; b = 8'd42; c = 8'd42; d = 8'd42;
        vec = 3'b111; select = 1'b0;
        $display("Testcase005: All values = 42, vec=3'b111, select=0");
        #1;

        check_outputs(8'd42, 1'b1, 1'b1, 1'b1, 3'b111);
    end
        endtask

    task testcase006;

    begin

        a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd0;
        vec = 3'b100; select = 1'b1;
        $display("Testcase006: d=0, vec=3'b100, select=1");
        #1;

        check_outputs(8'd0, 1'b0, 1'b0, 1'b0, 3'b000);
    end
        endtask

    task testcase007;

    begin

        a = 8'd15; b = 8'd15; c = 8'd100; d = 8'd100;
        vec = 3'b011; select = 1'b1;
        $display("Testcase007: a=b=15 (tie), vec=3'b011, select=1");
        #1;

        check_outputs(8'd15, 1'b1, 1'b1, 1'b1, 3'b111);
    end
        endtask

    task testcase008;

    begin

        a = 8'hFF; b = 8'hFE; c = 8'hFD; d = 8'hFC;
        vec = 3'b000; select = 1'b0;
        $display("Testcase008: a=FF, b=FE, c=FD, d=FC, vec=3'b000, select=0");
        #1;

        check_outputs(8'hFC, 1'b0, 1'b0, 1'b0, 3'b000);
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
        input [7:0] expected_min;
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_outv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min === (expected_min ^ min ^ expected_min) &&
                expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv)) begin
                $display("PASS");
                $display("  Outputs: min=%h, o0=%b, o1=%b, o2=%b, outv=%h",
                         min, o0, o1, o2, outv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h, o0=%b, o1=%b, o2=%b, outv=%h",
                         expected_min, expected_o0, expected_o1, expected_o2, expected_outv);
                $display("  Got:      min=%h, o0=%b, o1=%b, o2=%b, outv=%h",
                         min, o0, o1, o2, outv);
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
