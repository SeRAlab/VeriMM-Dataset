`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [39:0] vector_a;
    reg [39:0] vector_b;
    wire [15:0] dot_product_out;

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
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            vector_a = 40'h00_00_00_00_00;
            vector_b = 40'h00_00_00_00_00;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            vector_a = 40'h01_01_01_01_01;
            vector_b = 40'h01_01_01_01_01;

            #1;


            check_outputs(16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Element (Index 0)", test_num);
            vector_a = 40'h00_00_00_00_FF;
            vector_b = 40'h00_00_00_00_02;

            #1;


            check_outputs(16'h01FE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Element (Index 4)", test_num);
            vector_a = 40'h0A_00_00_00_00;
            vector_b = 40'h05_00_00_00_00;

            #1;


            check_outputs(16'h0032);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Values", test_num);

            vector_a = 40'h05_04_03_02_01;
            vector_b = 40'h01_02_03_04_05;

            #1;


            check_outputs(16'h0023);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values (Near 16-bit Limit)", test_num);

            vector_a = 40'hFF_00_00_00_00;
            vector_b = 40'hFF_00_00_00_00;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Large Products", test_num);

            vector_a = 40'h64_64_64_64_64;
            vector_b = 40'h32_32_32_32_32;

            #1;


            check_outputs(16'h61A8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Case (Truncation to 16-bit)", test_num);

            vector_a = 40'hFF_FF_FF_FF_FF;
            vector_b = 40'hFF_FF_FF_FF_FF;


            #1;



            check_outputs(16'hF605);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scattered Components", test_num);

            vector_a = 40'h0A_00_14_00_1E;
            vector_b = 40'h02_00_04_00_06;

            #1;


            check_outputs(16'h0118);
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
        testcase009();
        
        
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
        input [15:0] expected_dot_product_out;
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
