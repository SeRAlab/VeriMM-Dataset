`timescale 1ns/1ps

module ecc_scalar_mult_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] k;
    reg [7:0] x_in;
    reg [7:0] y_in;
    wire [7:0] x_out;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_scalar_mult dut (
        .k(k),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Scalar (k=1)", test_num);

        k = 4'd1;
        x_in = 8'h02;
        y_in = 8'h03;
        #1;

        check_outputs(8'h02, 8'h03);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Scalar (k=0)", test_num);

        k = 4'd0;
        x_in = 8'h02;
        y_in = 8'h03;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Point Doubling (k=2)", test_num);

        k = 4'd2;
        x_in = 8'h02;
        y_in = 8'h03;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Scalar k=3 (Double and Add)", test_num);

        k = 4'd3;
        x_in = 8'h02;
        y_in = 8'h03;
        #1;

        check_outputs(8'hFA, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Different Input Point", test_num);

        k = 4'd1;
        x_in = 8'h0A;
        y_in = 8'h20;
        #1;

        check_outputs(8'h0A, 8'h20);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Point at Infinity Input", test_num);

        k = 4'd5;
        x_in = 8'h00;
        y_in = 8'h00;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Scalar k=15", test_num);


        k = 4'd15;
        x_in = 8'h02;
        y_in = 8'h03;

        #1;


        check_outputs(8'h66, 8'hB2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_scalar_mult Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_x_out;
        input [7:0] expected_y_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
