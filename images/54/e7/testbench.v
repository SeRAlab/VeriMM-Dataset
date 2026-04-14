`timescale 1ns/1ps

module simple_alu_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] sel;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_alu dut (
        .a(a),
        .b(b),
        .sel(sel),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Simple Addition (10 + 20)", test_num);
        a = 8'h0A; b = 8'h14; sel = 2'b00;
        #1;

        check_outputs(8'h1E);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition with Overflow (128 + 128)", test_num);
        a = 8'h80; b = 8'h80; sel = 2'b00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Simple Subtraction (50 - 20)", test_num);
        a = 8'h32; b = 8'h14; sel = 2'b01;
        #1;

        check_outputs(8'h1E);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction with Negative Result (10 - 20)", test_num);
        a = 8'h0A; b = 8'h14; sel = 2'b01;
        #1;

        check_outputs(8'hF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bitwise AND (0xFF & 0x0F)", test_num);
        a = 8'hFF; b = 8'h0F; sel = 2'b10;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bitwise AND (0x55 & 0xAA)", test_num);
        a = 8'h55; b = 8'hAA; sel = 2'b10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Addition of zero (0xAA + 0x00)", test_num);
        a = 8'hAA; b = 8'h00; sel = 2'b00;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Subtraction to zero (0x55 - 0x55)", test_num);
        a = 8'h55; b = 8'h55; sel = 2'b01;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_alu Testbench");
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
        input [7:0] expected_result;
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
