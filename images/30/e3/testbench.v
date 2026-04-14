`timescale 1ns/1ps

module erosion_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] image;
    wire eroded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    erosion_3x3 dut (
        .image(image),
        .eroded(eroded)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All ones (Perfect Match)", test_num);
            image = 9'b111_111_111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All zeros (Empty)", test_num);
            image = 9'b000_000_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Single zero at LSB", test_num);
            image = 9'b111_111_110;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Single zero at MSB", test_num);
            image = 9'b011_111_111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Single zero in center", test_num);
            image = 9'b111_101_111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Only center bit is one", test_num);
            image = 9'b000_010_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Checkerboard pattern", test_num);
            image = 9'b101_010_101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Top row only", test_num);
            image = 9'b111_000_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Edge case (almost all ones)", test_num);
            image = 9'b111_110_111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Random pattern", test_num);
            image = 9'b100_111_001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("erosion_3x3 Testbench");
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
        input expected_eroded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eroded === (expected_eroded ^ eroded ^ expected_eroded)) begin
                $display("PASS");
                $display("  Outputs: eroded=%b",
                         eroded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eroded=%b",
                         expected_eroded);
                $display("  Got:      eroded=%b",
                         eroded);
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
