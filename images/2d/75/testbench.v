`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in_row0;
    reg [2:0] in_row1;
    reg [2:0] in_row2;
    wire [2:0] out_row0;
    wire [2:0] out_row1;
    wire [2:0] out_row2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .in_row0(in_row0),
        .in_row1(in_row1),
        .in_row2(in_row2),
        .out_row0(out_row0),
        .out_row1(out_row1),
        .out_row2(out_row2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            in_row0 = 3'b000; in_row1 = 3'b000; in_row2 = 3'b000;
            #1;

            check_outputs(3'b000, 3'b000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            in_row0 = 3'b111; in_row1 = 3'b111; in_row2 = 3'b111;
            #1;

            check_outputs(3'b111, 3'b111, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Center Pixel", test_num);


            in_row0 = 3'b000; in_row1 = 3'b010; in_row2 = 3'b000;
            #1;

            check_outputs(3'b111, 3'b111, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Left Corner Pixel", test_num);

            in_row0 = 3'b100; in_row1 = 3'b000; in_row2 = 3'b000;
            #1;

            check_outputs(3'b110, 3'b110, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Right Corner Pixel", test_num);

            in_row0 = 3'b001; in_row1 = 3'b000; in_row2 = 3'b000;
            #1;

            check_outputs(3'b011, 3'b011, 3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bottom-Left Corner Pixel", test_num);

            in_row0 = 3'b000; in_row1 = 3'b000; in_row2 = 3'b100;
            #1;

            check_outputs(3'b000, 3'b110, 3'b110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bottom-Right Corner Pixel", test_num);

            in_row0 = 3'b000; in_row1 = 3'b000; in_row2 = 3'b001;
            #1;

            check_outputs(3'b000, 3'b011, 3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Center Edge Pixel", test_num);

            in_row0 = 3'b010; in_row1 = 3'b000; in_row2 = 3'b000;
            #1;

            check_outputs(3'b111, 3'b111, 3'b000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-Left Edge Pixel", test_num);

            in_row0 = 3'b000; in_row1 = 3'b100; in_row2 = 3'b000;
            #1;

            check_outputs(3'b110, 3'b110, 3'b110);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sparse Pixels", test_num);

            in_row0 = 3'b100; in_row1 = 3'b000; in_row2 = 3'b001;

            #1;


            check_outputs(3'b110, 3'b111, 3'b011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("morphological_dilation Testbench");
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
        input [2:0] expected_out_row0;
        input [2:0] expected_out_row1;
        input [2:0] expected_out_row2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_row0 === (expected_out_row0 ^ out_row0 ^ expected_out_row0) &&
                expected_out_row1 === (expected_out_row1 ^ out_row1 ^ expected_out_row1) &&
                expected_out_row2 === (expected_out_row2 ^ out_row2 ^ expected_out_row2)) begin
                $display("PASS");
                $display("  Outputs: out_row0=%h, out_row1=%h, out_row2=%h",
                         out_row0, out_row1, out_row2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_row0=%h, out_row1=%h, out_row2=%h",
                         expected_out_row0, expected_out_row1, expected_out_row2);
                $display("  Got:      out_row0=%h, out_row1=%h, out_row2=%h",
                         out_row0, out_row1, out_row2);
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
