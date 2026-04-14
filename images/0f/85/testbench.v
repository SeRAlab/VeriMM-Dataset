`timescale 1ns/1ps

module multiplier_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_8bit dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 * 0", test_num);
            a = 8'h00;
            b = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 * 255", test_num);
            a = 8'h00;
            b = 8'hFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 255 * 0", test_num);
            a = 8'hFF;
            b = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 * 1", test_num);
            a = 8'h01;
            b = 8'h01;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 * 255", test_num);
            a = 8'h01;
            b = 8'hFF;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 255 * 255 (Max Value)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 16 * 16 (Power of 2)", test_num);
            a = 8'd16;
            b = 8'd16;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 128 * 2", test_num);
            a = 8'd128;
            b = 8'd2;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 * 15", test_num);
            a = 8'd15;
            b = 8'd15;
            #1;

            check_outputs(16'd225);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 170 * 85 (Alternating Bits)", test_num);
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(16'h3872);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 127 * 128", test_num);
            a = 8'd127;
            b = 8'd128;
            #1;

            check_outputs(16'd16256);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 * 7", test_num);
            a = 8'd3;
            b = 8'd7;
            #1;

            check_outputs(16'd21);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_8bit Testbench");
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
        testcase011();
        testcase012();
        
        
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
