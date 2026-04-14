`timescale 1ns/1ps

module wallace_tree_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wallace_tree_multiplier dut (
        .A(A),
        .B(B),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplying by zero", test_num);
            A = 8'd0;
            B = 8'd0;
            #1;

            check_outputs(16'd0);

            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=max", test_num);
            A = 8'd0;
            B = 8'd255;
            #1;

            check_outputs(16'd0);

            test_num = test_num + 1;
            $display("Test Case %0d: A=max, B=0", test_num);
            A = 8'd255;
            B = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity (1*1)", test_num);
            A = 8'd1;
            B = 8'd1;
            #1;

            check_outputs(16'd1);

            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=123", test_num);
            A = 8'd1;
            B = 8'd123;
            #1;

            check_outputs(16'd123);

            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=1", test_num);
            A = 8'd255;
            B = 8'd1;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 8-bit multiplication (255*255)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 (16*16)", test_num);
            A = 8'd16;
            B = 8'd16;
            #1;

            check_outputs(16'd256);

            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 (128*2)", test_num);
            A = 8'd128;
            B = 8'd2;
            #1;

            check_outputs(16'd256);

            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 (64*128)", test_num);
            A = 8'd64;
            B = 8'd128;
            #1;

            check_outputs(16'd8192);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed value (10*20)", test_num);
            A = 8'd10;
            B = 8'd20;
            #1;

            check_outputs(16'd200);

            test_num = test_num + 1;
            $display("Test Case %0d: Mixed value (123*45)", test_num);
            A = 8'd123;
            B = 8'd45;
            #1;

            check_outputs(16'd5535);

            test_num = test_num + 1;
            $display("Test Case %0d: Bit patterns (0x55*0xAA)", test_num);
            A = 8'h55;
            B = 8'hAA;
            #1;

            check_outputs(16'd14450);

            test_num = test_num + 1;
            $display("Test Case %0d: Large composite (200*150)", test_num);
            A = 8'd200;
            B = 8'd150;
            #1;

            check_outputs(16'd30000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wallace_tree_multiplier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
