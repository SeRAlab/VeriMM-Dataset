`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] vector_a;
    reg [4:0] vector_b;
    wire [9:0] dot_product_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .vector_a(vector_a),
        .vector_b(vector_b),
        .dot_product_out(dot_product_out)
    );
    task testcase001;

    begin
        test_num = 1;
        vector_a = 5'b00000;
        vector_b = 5'b00000;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        vector_a = 5'b11111;
        vector_b = 5'b11111;
        #1;

        check_outputs(10'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        vector_a = 5'b10101;
        vector_b = 5'b01010;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        vector_a = 5'b10000;
        vector_b = 5'b11111;
        #1;

        check_outputs(10'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        vector_a = 5'b01110;
        vector_b = 5'b11111;
        #1;

        check_outputs(10'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        vector_a = 5'b11011;
        vector_b = 5'b10110;
        #1;

        check_outputs(10'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        vector_a = 5'b00001;
        vector_b = 5'b00001;
        #1;

        check_outputs(10'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        vector_a = 5'b10001;
        vector_b = 5'b10001;
        #1;

        check_outputs(10'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dot_product Testbench");
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
        input [9:0] expected_dot_product_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dot_product_out === (expected_dot_product_out ^ dot_product_out ^ expected_dot_product_out)) begin
                $display("PASS");
                $display("  Outputs: dot_product_out=%h",
                         dot_product_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dot_product_out=%h",
                         expected_dot_product_out);
                $display("  Got:      dot_product_out=%h",
                         dot_product_out);
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
