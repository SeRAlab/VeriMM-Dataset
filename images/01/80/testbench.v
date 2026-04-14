`timescale 1ns/1ps

module multiplier_64x64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64x64 dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            a = 64'h0;
            b = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplicand is Zero", test_num);
            a = 64'h0;
            b = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplier is Zero", test_num);
            a = 64'hCAFE_BABE_DEAD_BEEF;
            b = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiply by One", test_num);
            a = 64'h1;
            b = 64'hABCD_EF01_2345_6789;
            #1;

            check_outputs(128'h0000_0000_0000_0000_ABCD_EF01_2345_6789);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Integers", test_num);
            a = 64'd100;
            b = 64'd200;
            #1;

            check_outputs(128'd20000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 32-bit Boundary Product", test_num);

            a = 64'h0000_0001_0000_0000;
            b = 64'h0000_0001_0000_0000;
            #1;

            check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values", test_num);

            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(128'hFFFF_FFFF_FFFF_FFFE_0000_0000_0000_0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits", test_num);
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'h5555_5555_5555_5555;

            #1;


            check_outputs(128'h38E3_8E38_E38E_38E3_1C71_C71C_71C7_1C72);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Prime-ish Numbers", test_num);
            a = 64'hDECA_FBAD_0000_0001;
            b = 64'h0000_0001_DEAD_BEEF;



            #1;




            check_outputs(128'h0000_0001_DEAD_BEEF_DECA_FBAD_0000_0001 + (128'hDECA_FBAD_0000_0000 * 128'hDEAD_BEEF));



            a = 64'hFFFF_0000_FFFF_0000;
            b = 64'h0000_FFFF_0000_FFFF;
            #1;

            check_outputs(128'hFFFE_0001_FFFE_0000_0001_FFFE_0001_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of Two Shifts", test_num);
            a = 64'h0000_0000_0000_0001 << 63;
            b = 64'd2;
            #1;

            check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000 >> 1);

            #1;


            check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64x64 Testbench");
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
        input [127:0] expected_product;
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
