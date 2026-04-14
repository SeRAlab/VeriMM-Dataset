`timescale 1ns/1ps

module dilation_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in_matrix;
    wire [8:0] out_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dilation_3x3 dut (
        .in_matrix(in_matrix),
        .out_matrix(out_matrix)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        in_matrix = 9'b000_000_000;
        #1;

        check_outputs(9'b000_000_000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        in_matrix = 9'b111_111_111;
        #1;

        check_outputs(9'b111_111_111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Center Pixel Only", test_num);
        in_matrix = 9'b000_010_000;
        #1;

        check_outputs(9'b111_111_111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Corner Pixel (Bottom-Left)", test_num);
        in_matrix = 9'b000_000_001;
        #1;

        check_outputs(9'b000_011_011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Corner Pixel (Top-Right)", test_num);
        in_matrix = 9'b100_000_000;
        #1;

        check_outputs(9'b110_110_000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge Pixel (Bottom-Middle)", test_num);
        in_matrix = 9'b000_000_010;
        #1;

        check_outputs(9'b000_111_111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge Pixel (Left-Middle)", test_num);
        in_matrix = 9'b000_001_000;
        #1;

        check_outputs(9'b011_011_011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sparse Pixels (Bits 0 and 8)", test_num);
        in_matrix = 9'b100_000_001;
        #1;

        check_outputs(9'b110_111_011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dilation_3x3 Testbench");
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
        input [8:0] expected_out_matrix;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_matrix === (expected_out_matrix ^ out_matrix ^ expected_out_matrix)) begin
                $display("PASS");
                $display("  Outputs: out_matrix=%h",
                         out_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_matrix=%h",
                         expected_out_matrix);
                $display("  Got:      out_matrix=%h",
                         out_matrix);
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
