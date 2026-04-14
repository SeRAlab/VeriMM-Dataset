`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [31:0] D;
    reg form;
    reg [1:0] vec;
    wire [31:0] Y1;
    wire [31:0] Y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .form(form),
        .vec(vec),
        .Y1(Y1),
        .Y2(Y2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mode 0, vec 0 (Basic Pair Addition)", test_num);
        A = 32'h0000_0005;
        B = 32'h0000_0010;
        C = 32'h0000_0002;
        D = 32'h0000_0020;
        form = 1'b0;
        vec = 2'b00;

        #1;


        check_outputs(32'h0000_0007, 32'h0000_0030);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mode 0, vec 01 (Verify output selection)", test_num);
        A = 32'h0000_1000;
        B = 32'h0000_2000;
        C = 32'h0000_0100;
        D = 32'h0000_0200;
        form = 1'b0;
        vec = 2'b01;

        #1;


        check_outputs(32'h0000_1100, 32'h0000_2200);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mode 1, vec 0 (Four-operand sum)", test_num);
        A = 32'h1; B = 32'h2; C = 32'h4; D = 32'h8;
        form = 1'b1;
        vec = 2'b00;

        #1;


        check_outputs(32'h0000_000F, 32'h0000_000F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Zero Inputs", test_num);
        A = 0; B = 0; C = 0; D = 0;
        form = 1'b0; vec = 2'b00;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Large values / Overflow check", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        C = 32'h0000_0001;
        D = 32'h0000_0005;
        form = 1'b0;
        vec = 2'b00;

        #1;


        check_outputs(32'h0000_0000, 32'h0000_0006);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mode 1 Max values", test_num);
        A = 32'h4000_0000;
        B = 32'h4000_0000;
        C = 32'h4000_0000;
        D = 32'h4000_0000;
        form = 1'b1;
        vec = 2'b00;

        #1;


        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Alternating bit patterns", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        C = 32'h55555555;
        D = 32'hAAAAAAAA;
        form = 1'b0;
        vec = 2'b00;

        #1;


        check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mode 0, vec 11 configuration", test_num);
        A = 32'h0000_000A;
        B = 32'h0000_000B;
        C = 32'h0000_000C;
        D = 32'h0000_000D;
        form = 1'b0;
        vec = 2'b11;


        #1;



        check_outputs(32'h0000_0016, 32'h0000_0018);
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
        input [31:0] expected_Y1;
        input [31:0] expected_Y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2)) begin
                $display("PASS");
                $display("  Outputs: Y1=%h, Y2=%h",
                         Y1, Y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%h, Y2=%h",
                         expected_Y1, expected_Y2);
                $display("  Got:      Y1=%h, Y2=%h",
                         Y1, Y2);
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
