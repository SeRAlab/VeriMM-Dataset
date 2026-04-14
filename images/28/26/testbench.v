`timescale 1ns/1ps

module jpeg_compression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in;
    wire [3:0] compressed_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_compression dut (
        .pixel_in(pixel_in),
        .compressed_out(compressed_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Boundary check - Range 0 lower bound (pixel_in = 0)", test_num);
        pixel_in = 8'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Range 0 mid value (pixel_in = 32)", test_num);
        pixel_in = 8'd32;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Boundary check - Range 0 upper bound (pixel_in = 63)", test_num);
        pixel_in = 8'd63;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary check - Range 1 lower bound (pixel_in = 64)", test_num);
        pixel_in = 8'd64;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Range 1 mid value (pixel_in = 100)", test_num);
        pixel_in = 8'd100;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Boundary check - Range 1 upper bound (pixel_in = 127)", test_num);
        pixel_in = 8'd127;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Boundary check - Range 2 lower bound (pixel_in = 128)", test_num);
        pixel_in = 8'd128;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Range 2 mid value (pixel_in = 160)", test_num);
        pixel_in = 8'd160;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Boundary check - Range 2 upper bound (pixel_in = 191)", test_num);
        pixel_in = 8'd191;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Boundary check - Range 3 lower bound (pixel_in = 192)", test_num);
        pixel_in = 8'd192;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Range 3 mid value (pixel_in = 224)", test_num);
        pixel_in = 8'd224;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Boundary check - Range 3 upper bound (pixel_in = 255)", test_num);
        pixel_in = 8'd255;
        #1;

        check_outputs(4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_compression Testbench");
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
        input [3:0] expected_compressed_out;
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
