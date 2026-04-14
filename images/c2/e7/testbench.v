`timescale 1ns/1ps

module bcd_converter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire invalid;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bcd_converter dut (
        .in(in),
        .invalid(invalid),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 0 (Valid Edge)", test_num);
        in = 4'd0;
        #10;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 5 (Valid Mid)", test_num);
        in = 4'd5;
        #10;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 9 (Valid Edge)", test_num);
        in = 4'd9;
        #10;
        #1;

        check_outputs(1'b0, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 10 (Invalid Edge)", test_num);
        in = 4'd10;
        #10;


        #1;



        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 13 (Invalid Mid)", test_num);
        in = 4'd13;
        #10;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 15 (Invalid Edge)", test_num);
        in = 4'd15;
        #10;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bcd_converter Testbench");
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
        input expected_invalid;
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_invalid === (expected_invalid ^ invalid ^ expected_invalid) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: invalid=%b, out=%h",
                         invalid, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: invalid=%b, out=%h",
                         expected_invalid, expected_out);
                $display("  Got:      invalid=%b, out=%h",
                         invalid, out);
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
