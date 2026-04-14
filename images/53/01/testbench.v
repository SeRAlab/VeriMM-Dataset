`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    reg ld;
    wire lz;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .ld(ld),
        .lz(lz),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Load zero", test_num);
            ld = 1'b1;
            d = 8'h00;
            #10;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Load all ones", test_num);
            ld = 1'b1;
            d = 8'hFF;
            #10;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Load bit 0", test_num);
            ld = 1'b1;
            d = 8'h01;
            #10;
            #1;

            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Load bit 7", test_num);
            ld = 1'b1;
            d = 8'h80;
            #10;
            #1;

            check_outputs(1'b0, 8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alternating pattern 0101", test_num);
            ld = 1'b1;
            d = 8'h55;
            #10;
            #1;

            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alternating pattern 1010", test_num);
            ld = 1'b1;
            d = 8'hAA;
            #10;
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: ld low with data present", test_num);
            ld = 1'b0;
            d = 8'hFF;
            #10;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Load middle bit", test_num);
            ld = 1'b1;
            d = 8'h10;
            #10;
            #1;

            check_outputs(1'b0, 8'h10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Load low nibble", test_num);
            ld = 1'b1;
            d = 8'h0F;
            #10;
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: ld low with zero data", test_num);
            ld = 1'b0;
            d = 8'h00;
            #10;
            #1;

            check_outputs(1'b1, 8'h00);
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
        input expected_lz;
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lz === (expected_lz ^ lz ^ expected_lz) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: lz=%b, z=%h",
                         lz, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lz=%b, z=%h",
                         expected_lz, expected_z);
                $display("  Got:      lz=%b, z=%h",
                         lz, z);
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
