`timescale 1ns/1ps

module fixed_point_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'h00;
            b = 8'h00;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'h10;
            b = 8'h10;

            #1;


            check_outputs(16'h0100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'h20;
            b = 8'h30;

            #1;


            check_outputs(16'h0600);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'h08;
            b = 8'h08;

            #1;


            check_outputs(16'h0040);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'hFF;
            b = 8'h10;

            #1;


            check_outputs(16'h0FF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h18;
            b = 8'h24;

            #1;


            check_outputs(16'h0360);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'h01;
            b = 8'h01;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'hFF;
            b = 8'hFF;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'h80;
            b = 8'h04;

            #1;


            check_outputs(16'h0200);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 8'h4C;
            b = 8'h12;

            #1;


            check_outputs(16'h0558);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_multiplier Testbench");
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
        input [15:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
