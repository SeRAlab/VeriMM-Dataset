`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] pix1;
    reg [15:0] pix2;
    wire [6:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pix1(pix1),
        .pix2(pix2),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical inputs", test_num);
            pix1 = 16'hABCD;
            pix2 = 16'hABCD;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum difference (All bits flip)", test_num);
            pix1 = 16'hFFFF;
            pix2 = 16'h0000;

            #1;


            check_outputs(7'd125);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Red difference only", test_num);
            pix1 = 16'h001F;
            pix2 = 16'h000A;

            #1;


            check_outputs(7'd21);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Green difference only", test_num);
            pix1 = 16'h0000;
            pix2 = 16'h07E0;

            #1;


            check_outputs(7'd63);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Blue difference only", test_num);
            pix1 = 16'hF800;
            pix2 = 16'h4000;

            #1;


            check_outputs(7'd23);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed differences", test_num);


            pix1 = 16'h5505;
            pix2 = 16'hA14F;




            #1;





            check_outputs(7'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimal difference on all components", test_num);


            pix1 = 16'h0821;
            pix2 = 16'h0000;
            #1;

            check_outputs(7'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns", test_num);


            pix1 = 16'hAAAA;
            pix2 = 16'h5555;




            #1;





            check_outputs(7'd43);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [6:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
