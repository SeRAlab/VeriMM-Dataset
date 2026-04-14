`timescale 1ns/1ps

module add_const_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] const_val;
    reg [3:0] in_val;
    wire [3:0] out_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_const dut (
        .const_val(const_val),
        .in_val(in_val),
        .out_val(out_val)
    );
    task testcase001;

    begin
        $display("Test Case 001: Small sum (0 + 0)");
        in_val = 4'd0;
        const_val = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Simple addition (2 + 3)");
        in_val = 4'd2;
        const_val = 4'd3;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Boundary sum equal to 7 (4 + 3)");
        in_val = 4'd4;
        const_val = 4'd3;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Boundary sum equal to 7 (7 + 0)");
        in_val = 4'd7;
        const_val = 4'd0;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Saturation at sum 8 (4 + 4)");
        in_val = 4'd4;
        const_val = 4'd4;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Saturation with high const_val (0 + 8)");
        in_val = 4'd0;
        const_val = 4'd8;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Saturation with high in_val (10 + 0)");
        in_val = 4'd10;
        const_val = 4'd0;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Maximum values saturation (15 + 15)");
        in_val = 4'hF;
        const_val = 4'hF;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Saturation just above limit (1 + 7)");
        in_val = 4'd1;
        const_val = 4'd7;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: Input at 7, constant at 1");
        in_val = 4'd7;
        const_val = 4'd1;
        #1;

        check_outputs(4'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_const Testbench");
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
        input [3:0] expected_out_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_val === (expected_out_val ^ out_val ^ expected_out_val)) begin
                $display("PASS");
                $display("  Outputs: out_val=%h",
                         out_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_val=%h",
                         expected_out_val);
                $display("  Got:      out_val=%h",
                         out_val);
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
