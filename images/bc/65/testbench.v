`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg [1:0] sel;
    wire [1:0] out;

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
            A = 3'b001; B = 3'b000; sel = 2'b00;
            $display("Test %0d: sel=00 (Bit 0), A=001, B=000", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 3'b000; B = 3'b001; sel = 2'b00;
            $display("Test %0d: sel=00 (Bit 0), A=000, B=001", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 3'b111; B = 3'b001; sel = 2'b00;
            $display("Test %0d: sel=00 (Bit 0), A=111, B=001", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 3'b010; B = 3'b001; sel = 2'b01;
            $display("Test %0d: sel=01 (Bit 1), A=010, B=001", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 3'b101; B = 3'b010; sel = 2'b01;
            $display("Test %0d: sel=01 (Bit 1), A=101, B=010", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 3'b111; B = 3'b010; sel = 2'b01;
            $display("Test %0d: sel=01 (Bit 1), A=111, B=010", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 3'b100; B = 3'b011; sel = 2'b10;
            $display("Test %0d: sel=10 (Bit 2), A=100, B=011", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 3'b011; B = 3'b100; sel = 2'b10;
            $display("Test %0d: sel=10 (Bit 2), A=011, B=100", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 3'b101; B = 3'b111; sel = 2'b10;
            $display("Test %0d: sel=10 (Bit 2), A=101, B=111", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 3'b111; B = 3'b000; sel = 2'b11;
            $display("Test %0d: sel=11 (Invalid), A=111, B=000", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A = 3'b110; B = 3'b001; sel = 2'b00;
            $display("Test %0d: sel=00, A=110, B=001, Expecting A < B (Bit 0 check)", test_num);
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_out;
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
