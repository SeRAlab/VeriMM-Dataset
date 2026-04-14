`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg arith_shift;
    reg [31:0] b;
    reg [2:0] op;
    reg [4:0] shamt;
    reg sub_enable;
    wire bge;
    wire bgeu;
    wire eq;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .arith_shift(arith_shift),
        .b(b),
        .op(op),
        .shamt(shamt),
        .sub_enable(sub_enable),
        .bge(bge),
        .bgeu(bgeu),
        .eq(eq),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;

        a = 32'd15;
        b = 32'd27;
        op = 3'b000;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd0;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 32'h0000002A);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;

        a = 32'd50;
        b = 32'd20;
        op = 3'b000;
        sub_enable = 1'b1;
        arith_shift = 1'b0;
        shamt = 5'd0;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 32'h0000001E);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;

        a = 32'hF0F0F0F0;
        b = 32'hAAAAAAAA;
        op = 3'b111;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd0;



        #1;




        check_outputs(1'b1, 1'b1, 1'b0, 32'hA0A0A0A0);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;

        a = 32'h12340000;
        b = 32'h00005678;
        op = 3'b110;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 32'h12345678);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;

        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        op = 3'b100;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd0;


        #1;



        check_outputs(1'b0, 1'b1, 1'b0, 32'hFFFFFFFF);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;

        a = 32'h00000001;
        b = 32'h00000000;
        op = 3'b001;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd8;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 32'h00000100);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;

        a = 32'h80000000;
        b = 32'h00000000;
        op = 3'b101;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd4;


        #1;



        check_outputs(1'b0, 1'b1, 1'b0, 32'h08000000);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;

        a = 32'hF0000000;
        b = 32'h00000000;
        op = 3'b101;
        sub_enable = 1'b0;
        arith_shift = 1'b1;
        shamt = 5'd4;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 32'hFF000000);
    end
    endtask

    task testcase009;

    begin
        test_num = 9;

        a = 32'h12345678;
        b = 32'h12345678;
        op = 3'b000;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1, 32'h2468ACF0);
    end
    endtask

    task testcase010;

    begin
        test_num = 10;


        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        op = 3'b010;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd0;




        #1;





        check_outputs(1'b0, 1'b1, 1'b0, 32'h00000001);
    end
    endtask

    task testcase011;

    begin
        test_num = 11;


        a = 32'h00000001;
        b = 32'hFFFFFFFF;
        op = 3'b011;
        sub_enable = 1'b0;
        arith_shift = 1'b0;
        shamt = 5'd0;




        #1;





        check_outputs(1'b1, 1'b0, 1'b0, 32'h00000001);
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
        input expected_bge;
        input expected_bgeu;
        input expected_eq;
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bge === (expected_bge ^ bge ^ expected_bge) &&
                expected_bgeu === (expected_bgeu ^ bgeu ^ expected_bgeu) &&
                expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: bge=%b, bgeu=%b, eq=%b, res=%h",
                         bge, bgeu, eq, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bge=%b, bgeu=%b, eq=%b, res=%h",
                         expected_bge, expected_bgeu, expected_eq, expected_res);
                $display("  Got:      bge=%b, bgeu=%b, eq=%b, res=%h",
                         bge, bgeu, eq, res);
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
