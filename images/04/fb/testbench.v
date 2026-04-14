`timescale 1ns/1ps

module alu_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg [2:0] ctrl;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_64bit dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Basic (5 + 3)", test_num);
        a = 64'd5;
        b = 64'd3;
        ctrl = 3'b000;
        #1;

        check_outputs(64'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Max Value Wrap", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'd1;
        ctrl = 3'b000;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Basic (10 - 4)", test_num);
        a = 64'd10;
        b = 64'd4;
        ctrl = 3'b001;
        #1;

        check_outputs(64'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Negative Result (5 - 10)", test_num);
        a = 64'd5;
        b = 64'd10;
        ctrl = 3'b001;

        #1;


        check_outputs(64'hFFFF_FFFF_FFFF_FFFB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        a = 64'hAAAA_AAAA_0000_0000;
        b = 64'hFFFF_FFFF_FFFF_FFFF;
        ctrl = 3'b010;
        #1;

        check_outputs(64'hAAAA_AAAA_0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        a = 64'h5555_5555_0000_0000;
        b = 64'h0000_0000_AAAA_AAAA;
        ctrl = 3'b011;
        #1;

        check_outputs(64'h5555_5555_AAAA_AAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        a = 64'hF0F0_F0F0_F0F0_F0F0;
        b = 64'hFFFF_FFFF_FFFF_FFFF;
        ctrl = 3'b100;
        #1;

        check_outputs(64'h0F0F_0F0F_0F0F_0F0F);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Large Numbers", test_num);
        a = 64'h1234_5678_9ABC_DEF0;
        b = 64'h1111_1111_1111_1111;
        ctrl = 3'b000;
        #1;

        check_outputs(64'h2345_6789_ABCE_FFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_64bit Testbench");
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
        input [63:0] expected_result;
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
