`timescale 1ns/1ps

module png_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] pixel_data;
    reg valid;
    wire [7:0] compressed_data;
    wire compressed_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compressor dut (
        .pixel_data(pixel_data),
        .valid(valid),
        .compressed_data(compressed_data),
        .compressed_valid(compressed_valid)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

        begin
            rst_n = 0;
            valid = 0;
            pixel_data = 0;
            repeat (2) @(posedge clk);
            rst_n = 1;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Literal Sequence (No Repetition)", test_num);
            reset_dut();


            @(posedge clk);
            pixel_data = 8'h10; valid = 1; @(posedge clk);
            pixel_data = 8'h20; valid = 1; @(posedge clk);
            pixel_data = 8'h30; valid = 1; @(posedge clk);
            pixel_data = 8'h40; valid = 1; @(posedge clk);
            valid = 0;


            repeat (5) @(posedge clk);



            #1;




            check_outputs(8'h40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Repeated Sequence (AAAAA...)", test_num);
            reset_dut();


            repeat (8) begin
                pixel_data = 8'hAA;
                valid = 1;
                @(posedge clk);
            end
            valid = 0;

            repeat (10) @(posedge clk);



            #1;




            check_outputs(compressed_data, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Pattern Repetition (ABCABC)", test_num);
            reset_dut();


            pixel_data = 8'h01; valid = 1; @(posedge clk);
            pixel_data = 8'h02; valid = 1; @(posedge clk);
            pixel_data = 8'h03; valid = 1; @(posedge clk);
            pixel_data = 8'h01; valid = 1; @(posedge clk);
            pixel_data = 8'h02; valid = 1; @(posedge clk);
            pixel_data = 8'h03; valid = 1; @(posedge clk);
            valid = 0;

            repeat (10) @(posedge clk);
            #1;

            check_outputs(compressed_data, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Strobe Control", test_num);
            reset_dut();

            pixel_data = 8'hFF; valid = 1; @(posedge clk);
            valid = 0; repeat(2) @(posedge clk);
            pixel_data = 8'hEE; valid = 1; @(posedge clk);
            valid = 0;

            repeat (5) @(posedge clk);
            #1;

            check_outputs(compressed_data, 1'b1);
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
        input [7:0] expected_compressed_data;
        input expected_compressed_valid;
        begin
            if (expected_compressed_data === (expected_compressed_data ^ compressed_data ^ expected_compressed_data) &&
                expected_compressed_valid === (expected_compressed_valid ^ compressed_valid ^ expected_compressed_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_data=%h, compressed_valid=%b",
                         compressed_data, compressed_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_data=%h, compressed_valid=%b",
                         expected_compressed_data, expected_compressed_valid);
                $display("  Got:      compressed_data=%h, compressed_valid=%b",
                         compressed_data, compressed_valid);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,pixel_data, valid, compressed_data, compressed_valid);
    end

endmodule
