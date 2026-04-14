`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg [2:0] C;
    wire [2:0] Y1;
    wire [2:0] Y2;
    wire [2:0] Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 3'b000; B = 3'b000; C = 3'b000;
        $display("Test %0d: All zeros", test_num);
        #1;

        check_outputs(3'b000, 3'b000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 3'b111; B = 3'b111; C = 3'b111;
        $display("Test %0d: All ones", test_num);
        #1;

        check_outputs(3'b111, 3'b111, 3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 3'b101; B = 3'b011; C = 3'b110;
        $display("Test %0d: Mixed values 1", test_num);



        #1;




        check_outputs(3'b001, 3'b111, 3'b101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 3'b110; B = 3'b101; C = 3'b011;
        $display("Test %0d: Mixed values 2", test_num);



        #1;




        check_outputs(3'b100, 3'b111, 3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 3'b010; B = 3'b110; C = 3'b011;
        $display("Test %0d: Mixed values 3", test_num);



        #1;




        check_outputs(3'b010, 3'b011, 3'b101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 3'b100; B = 3'b010; C = 3'b001;
        $display("Test %0d: Orthogonal bits", test_num);



        #1;




        check_outputs(3'b000, 3'b101, 3'b011);
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
        input [2:0] expected_Y1;
        input [2:0] expected_Y2;
        input [2:0] expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y1=%h, Y2=%h, Y3=%h",
                         Y1, Y2, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%h, Y2=%h, Y3=%h",
                         expected_Y1, expected_Y2, expected_Y3);
                $display("  Got:      Y1=%h, Y2=%h, Y3=%h",
                         Y1, Y2, Y3);
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
