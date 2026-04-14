`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b1010;
        B = 4'b1100;
        sel = 2'b00;
        $display("Test %0d: AND operation - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b1010;
        B = 4'b1100;
        sel = 2'b01;
        $display("Test %0d: OR operation - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1010;
        B = 4'b1100;
        sel = 2'b10;
        $display("Test %0d: XOR operation - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1010;
        B = 4'b1100;
        sel = 2'b11;
        $display("Test %0d: NOR operation - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1111;
        B = 4'b0000;
        sel = 2'b00;
        $display("Test %0d: AND with all zeros - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b0101;
        B = 4'b1111;
        sel = 2'b01;
        $display("Test %0d: OR with all ones - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b1011;
        B = 4'b1011;
        sel = 2'b10;
        $display("Test %0d: XOR same values - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b0000;
        B = 4'b0000;
        sel = 2'b11;
        $display("Test %0d: NOR all zeros - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1010;
        B = 4'b1111;
        sel = 2'b10;
        $display("Test %0d: XOR with all ones - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b0011;
        B = 4'b0101;
        sel = 2'b11;
        $display("Test %0d: NOR mixed bits - A=%b, B=%b, sel=%b", test_num, A, B, sel);
        #1;

        check_outputs(4'b1000);
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
        input [3:0] expected_out;
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
