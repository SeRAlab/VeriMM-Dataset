`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] op;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .op(op),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 32'd150;
        B = 32'd50;
        op = 3'b000;
        $write("Testcase %0d: Addition (150 + 50) - ", test_num);
        #1;

        check_outputs(32'd200);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        op = 3'b000;
        $write("Testcase %0d: Addition Overflow (Max + 1) - ", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 32'd1000;
        B = 32'd350;
        op = 3'b001;
        $write("Testcase %0d: Subtraction (1000 - 350) - ", test_num);
        #1;

        check_outputs(32'd650);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 32'd0;
        B = 32'd1;
        op = 3'b001;
        $write("Testcase %0d: Subtraction Underflow (0 - 1) - ", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 32'hF0F0F0F0;
        B = 32'hAAAA5555;
        op = 3'b010;
        $write("Testcase %0d: Bitwise AND - ", test_num);
        #1;

        check_outputs(32'hA0A05050);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 32'hFFFF0000;
        B = 32'h0000FFFF;
        op = 3'b010;
        $write("Testcase %0d: Bitwise AND (Zero result) - ", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 32'h12340000;
        B = 32'h00005678;
        op = 3'b011;
        $write("Testcase %0d: Bitwise OR - ", test_num);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        op = 3'b011;
        $write("Testcase %0d: Bitwise OR (All ones) - ", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 32'h12345678;
        B = 32'h12345678;
        op = 3'b100;
        $write("Testcase %0d: Bitwise XOR (Same values) - ", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 32'h00000000;
        B = 32'hFFFFFFFF;
        op = 3'b100;
        $write("Testcase %0d: Bitwise XOR (Complement) - ", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
