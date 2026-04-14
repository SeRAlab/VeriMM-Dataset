`timescale 1ns/1ps

module adder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire Carry;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_8bit dut (
        .A(A),
        .B(B),
        .Carry(Carry),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd0; B = 8'd0;
        $display("Testcase %0d: Adding zero values (0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'd50; B = 8'd25;
        $display("Testcase %0d: Simple addition without carry (50 + 25)", test_num);
        #1;

        check_outputs(1'b0, 8'd75);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd255; B = 8'd0;
        $display("Testcase %0d: Max value plus zero (255 + 0)", test_num);
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd128; B = 8'd127;
        $display("Testcase %0d: Max value without carry (128 + 127 = 255)", test_num);
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'd128; B = 8'd128;
        $display("Testcase %0d: Minimum carry-out (128 + 128 = 256)", test_num);
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'hFF; B = 8'h01;
        $display("Testcase %0d: Maximum 8-bit value plus one (255 + 1)", test_num);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'd200; B = 8'd100;
        $display("Testcase %0d: Large sum with carry (200 + 100 = 300)", test_num);

        #1;


        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'hFF; B = 8'hFF;
        $display("Testcase %0d: Maximum values (255 + 255 = 510)", test_num);

        #1;


        check_outputs(1'b1, 8'hFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_8bit Testbench");
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
        input expected_Carry;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Carry=%b, Sum=%h",
                         Carry, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%b, Sum=%h",
                         expected_Carry, expected_Sum);
                $display("  Got:      Carry=%b, Sum=%h",
                         Carry, Sum);
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
