`timescale 1ns/1ps

module mult_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [7:0] B;
    wire [23:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mult_16bit dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'd0;
        B = 8'd0;
        $display("Test %0d: Zero Multiplicand and Multiplier (0 * 0)", test_num);
        #1;

        check_outputs(24'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'hFFFF;
        B = 8'd0;
        $display("Test %0d: Zero Multiplier (65535 * 0)", test_num);
        #1;

        check_outputs(24'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'h1234;
        B = 8'd1;
        $display("Test %0d: Identity Multiplier (0x1234 * 1)", test_num);
        #1;

        check_outputs(24'h001234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'd1;
        B = 8'hFF;
        $display("Test %0d: Identity Multiplicand (1 * 255)", test_num);
        #1;

        check_outputs(24'h0000FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'hFFFF;
        B = 8'hFF;
        $display("Test %0d: Maximum Values (0xFFFF * 0xFF)", test_num);

        #1;


        check_outputs(24'hFEFF01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'd256;
        B = 8'd16;
        $display("Test %0d: Power of Two (256 * 16)", test_num);
        #1;

        check_outputs(24'd4096);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'hAAAA;
        B = 8'h55;
        $display("Test %0d: Pattern Test (0xAAAA * 0x55)", test_num);

        #1;


        check_outputs(24'h38AA72);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'd12345;
        B = 8'd123;
        $display("Test %0d: Random Large Values (12345 * 123)", test_num);

        #1;


        check_outputs(24'h172BA3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 16'h00FF;
        B = 8'h0F;
        $display("Test %0d: Small Values (255 * 15)", test_num);

        #1;


        check_outputs(24'h000EF1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 16'h8000;
        B = 8'h80;
        $display("Test %0d: MSB Set Only (0x8000 * 0x80)", test_num);

        #1;


        check_outputs(24'h400000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mult_16bit Testbench");
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
        input [23:0] expected_result;
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
