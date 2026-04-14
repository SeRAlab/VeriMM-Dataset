`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'd0;
            b = 32'd0;
            $display("Test %0d: Zero multiply (0 * 0)", test_num);
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'd1;
            b = 32'd1;
            $display("Test %0d: Identity multiply (1 * 1)", test_num);
            #1;

            check_outputs(64'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hFFFFFFFF;
            b = 32'd1;
            $display("Test %0d: Max value by one", test_num);
            #1;

            check_outputs(64'h00000000FFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            $display("Test %0d: Max value by Max value", test_num);
            #1;

            check_outputs(64'hFFFFFFFF00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'd12345;
            b = 32'd67890;
            $display("Test %0d: Common small integers", test_num);
            #1;

            check_outputs(64'd838102050);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h80000000;
            b = 32'd2;
            $display("Test %0d: Power of two shift-like multiplication", test_num);
            #1;

            check_outputs(64'h0000000100000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'hDEADBEEF;
            b = 32'hCAFEBABE;
            $display("Test %0d: Large arbitrary hex values", test_num);
            #1;

            check_outputs(64'hB09A4363ED9967D2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h55555555;
            b = 32'hAAAAAAAA;
            $display("Test %0d: Alternating bit patterns", test_num);
            #1;

            check_outputs(64'h38E38E3871C71C72);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'd0;
            b = 32'hFFFFFFFF;
            $display("Test %0d: Zero by max value", test_num);
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'h0000FFFF;
            b = 32'h0000FFFF;
            $display("Test %0d: 16-bit max values", test_num);
            #1;

            check_outputs(64'h00000000FFFE0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [63:0] expected_product;
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
