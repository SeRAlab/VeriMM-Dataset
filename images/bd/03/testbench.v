`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALU_FUNC;
    reg [15:0] a;
    reg [15:0] b;
    wire OF_detect;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_FUNC(ALU_FUNC),
        .a(a),
        .b(b),
        .OF_detect(OF_detect),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 16'h1000; b = 16'h2000; ALU_FUNC = 3'b000;
        #1;

        check_outputs(1'b0, 32'h00003000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 16'hFFFF; b = 16'h0001; ALU_FUNC = 3'b000;

        #1;


        check_outputs(1'b1, 32'h00010000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 16'h0010; b = 16'h0005; ALU_FUNC = 3'b001;
        #1;

        check_outputs(1'b0, 32'h0000000B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 16'h0005; b = 16'h000A; ALU_FUNC = 3'b001;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 16'd100; b = 16'd50; ALU_FUNC = 3'b010;
        #1;

        check_outputs(1'b0, 32'd5000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 16'hFFFF; b = 16'h0002; ALU_FUNC = 3'b010;

        #1;


        check_outputs(1'b0, 32'h0001FFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 16'd100; b = 16'd7; ALU_FUNC = 3'b011;


        #1;



        check_outputs(1'b0, 32'h0002000E);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 16'hF0F0; b = 16'hAAAA; ALU_FUNC = 3'b100;
        #1;

        check_outputs(1'b0, 32'h0000A0A0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 16'hF0F0; b = 16'hAAAA; ALU_FUNC = 3'b101;
        #1;

        check_outputs(1'b0, 32'h0000FAFA);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 16'hFFFF; b = 16'hFFFF; ALU_FUNC = 3'b010;

        #1;


        check_outputs(1'b0, 32'hFFFE0001);
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
        input expected_OF_detect;
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OF_detect === (expected_OF_detect ^ OF_detect ^ expected_OF_detect) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: OF_detect=%b, out=%h",
                         OF_detect, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OF_detect=%b, out=%h",
                         expected_OF_detect, expected_out);
                $display("  Got:      OF_detect=%b, out=%h",
                         OF_detect, out);
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
