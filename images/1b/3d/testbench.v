`timescale 1ns/1ps

module multiplier_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_16bit dut (
        .A(A),
        .B(B),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 16'h0000;
            B = 16'h0000;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 16'h0001;
            B = 16'hABCD;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'h0000;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'h0001;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 16'd100;
            B = 16'd100;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(32'd10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'hFFFF;
            $display("Test %0d: %h * %h", test_num, A, B);

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 16'h0100;
            B = 16'h0100;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 16'hAAAA;
            B = 16'h5555;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h38E31C1E);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 16'h1234;
            B = 16'h5678;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h06256160);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 16'hFFFE;
            B = 16'h0002;
            $display("Test %0d: %h * %h", test_num, A, B);
            #1;

            check_outputs(32'h0001FFFC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_16bit Testbench");
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
        input [31:0] expected_product;
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
