`timescale 1ns/1ps

module png_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] rgb_in;
    wire [7:0] compressed_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compressor dut (
        .rgb_in(rgb_in),
        .compressed_out(compressed_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Pure Black", test_num);
        rgb_in = 24'h000000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Pure White", test_num);
        rgb_in = 24'hFFFFFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Pure Red", test_num);
        rgb_in = 24'hFF0000;
        #1;

        check_outputs(8'd85);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Pure Green", test_num);
        rgb_in = 24'h00FF00;
        #1;

        check_outputs(8'd85);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Pure Blue", test_num);
        rgb_in = 24'h0000FF;
        #1;

        check_outputs(8'd85);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Balanced Grey", test_num);
        rgb_in = 24'h808080;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Mixed High Values", test_num);
        rgb_in = 24'hABCDEF;
        #1;

        check_outputs(8'd205);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Mixed Low Values", test_num);
        rgb_in = 24'h123456;
        #1;

        check_outputs(8'd52);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Rounding Down Check", test_num);
        rgb_in = 24'h0A0A0B;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Rounding Up Boundary", test_num);
        rgb_in = 24'h0A0B0B;
        #1;

        check_outputs(8'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compressor Testbench");
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
        input [7:0] expected_compressed_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h",
                         compressed_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h",
                         expected_compressed_out);
                $display("  Got:      compressed_out=%h",
                         compressed_out);
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
